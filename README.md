# YinegelOS APT Deposu

```bash
echo "deb [trusted=yes] https://KULLANICI.github.io/REPO stable main" | sudo tee /etc/apt/sources.list.d/yinegelos.list
sudo apt update
sudo apt install yinegelos-info yinegelos-cleaner yinegelos-basic-calc
```

Güncellemek için: `pool/main/` içine yeni .deb ekle, `./update-repo.sh` çalıştır, commit & push.
