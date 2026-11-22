#!/usr/bin/env bash
# YinegelOS APT deposu güncelleme betiği
# Kullanım:  ./update-repo.sh            -> imzasız (trusted=yes ile kullanılır)
#            ./update-repo.sh KEY_ID     -> GPG ile imzalar (önerilen)
# Gereken paket: dpkg-dev  (sudo apt install dpkg-dev gnupg)
set -euo pipefail
cd "$(dirname "$0")"

SUITE="stable"
COMP="main"
ARCHS=("amd64" "all")
KEY_ID="${1:-}"

# .deb dosya adlarını standart forma getir: paket_sürüm_mimari.deb
# (dpkg-scanpackages --arch, standart olmayan adları sessizce atlar)
for f in pool/main/*.deb; do
  [ -e "$f" ] || continue
  pkg=$(dpkg-deb -f "$f" Package); ver=$(dpkg-deb -f "$f" Version); ar_=$(dpkg-deb -f "$f" Architecture)
  new="pool/main/${pkg}_${ver//:/%3a}_${ar_}.deb"
  [ "$f" = "$new" ] || mv -v "$f" "$new"
done

rm -rf dists
for arch in amd64; do
  d="dists/$SUITE/$COMP/binary-$arch"
  mkdir -p "$d"
  # -a amd64 verince "all" mimarisindeki paketler de dahil edilir
  dpkg-scanpackages --arch "$arch" pool/ /dev/null > "$d/Packages" 2>/dev/null
  gzip -9 -k -f "$d/Packages"
  xz  -9 -k -f "$d/Packages"
done

# Release dosyası
rel="dists/$SUITE/Release"
{
  echo "Origin: YinegelOS"
  echo "Label: YinegelOS"
  echo "Suite: $SUITE"
  echo "Codename: $SUITE"
  echo "Architectures: amd64"
  echo "Components: $COMP"
  echo "Description: YinegelOS APT deposu"
  echo "Date: $(LC_ALL=C date -Ru)"
  for algo in MD5Sum SHA1 SHA256; do
    case $algo in MD5Sum) cmd=md5sum;; SHA1) cmd=sha1sum;; SHA256) cmd=sha256sum;; esac
    echo "$algo:"
    (cd "dists/$SUITE" && find . -type f ! -name 'Release*' ! -name 'InRelease' | sort | while read -r f; do
      printf " %s %16d %s\n" "$($cmd "$f" | cut -d' ' -f1)" "$(stat -c%s "$f")" "${f#./}"
    done)
  done
} > "$rel"

if [ -n "$KEY_ID" ]; then
  gpg --yes --default-key "$KEY_ID" -abs -o "dists/$SUITE/Release.gpg" "$rel"
  gpg --yes --default-key "$KEY_ID" --clearsign -o "dists/$SUITE/InRelease" "$rel"
  gpg --export "$KEY_ID" > yinegelos-archive-keyring.gpg
  echo "Imzalandı. Anahtar: yinegelos-archive-keyring.gpg"
else
  echo "Imzasız oluşturuldu (kullanırken [trusted=yes] gerekir)."
fi
echo "Tamam."
