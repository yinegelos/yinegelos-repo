# YinegelOS APT Deposu

YinegelOS paketlerinin bulunduğu APT deposu. GitHub Pages üzerinden yayınlanır.

## Depoyu ekleme

```bash
echo "deb [trusted=yes] https://yinegelos.github.io/yinegelos-repo stable main" | sudo tee /etc/apt/sources.list.d/yinegelos.list
sudo apt update
```

## Paket kurma

```bash
sudo apt install yinegelos-info yinegelos-cleaner yinegelos-basic-calc
```

## Paketler

| Paket | Sürüm | Mimari |
|---|---|---|
| yinegelos-info | 1.0 | amd64 |
| yinegelos-cleaner | 1.0 | amd64 |
| yinegelos-basic-calc | 1.0 | amd64 |
| pardus-mycomputer | 0.8.0 | all |
| mint-common | 9.9.9-yinegelos | all |
| mint-info-xfce | 9.9.9-yinegelos | all |
| mint-live-session | 9.9.9-yinegelos | all |
| mint-upgrade-info | 9.9.9-yinegelos | all |
| mintbackup | 9.9.9-yinegelos | all |
| mintinstall | 9.9.9-yinegelos | all |
| mintreport | 9.9.9-yinegelos | all |
| mintsystem | 9.9.9-yinegelos | all |
| mintupdate | 9.9.9-yinegelos | all |
| mintupgrade | 9.9.9-yinegelos | all |
| mintwelcome | 9.9.9-yinegelos | all |

`mint*` paketleri sürüm numarası yüksek olduğu için gerçek Linux Mint paketlerinin yerine geçen yer tutucu (sahte) paketlerdir.

## Depoyu kaldırma

```bash
sudo rm /etc/apt/sources.list.d/yinegelos.list
sudo apt update
```

## Yeni paket ekleme (geliştiriciler için)

```bash
sudo apt install dpkg-dev          # bir kez
cp yeni-paket.deb pool/main/
./update-repo.sh                   # Packages ve Release dosyalarını yeniler
git add .
git commit -m "yeni paket eklendi"
git push
```

Ardından kullanıcılar `sudo apt update` ile yeni paketi görür.

## Not

`[trusted=yes]` APT'nin imza doğrulamasını atlar. Depo ileride GPG ile imzalanırsa bu seçenek yerine `[signed-by=...]` kullanılmalıdır.
