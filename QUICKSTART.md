# ⚡ Быстрый старт за 3 минуты

## 1️⃣ Подготовка (30 сек)
```bash
# Установите Docker если его нет
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh

# Установите qrencode
sudo apt update && sudo apt install -y qrencode

# Перейдите в папку проекта
cd /home/kirill/DO/root/new_xray
```

## 2️⃣ Генерация конфигурации (1 мин)
```bash
./generate.sh
```
**Введите:**
- 📧 Ваш email: `admin@example.com`
- 🌐 IP сервера: `YOUR_SERVER_IP`

## 3️⃣ Запуск (30 сек)
```bash
./start.sh
```

## 4️⃣ Проверка (30 сек)
```bash
./status.sh
```

## 📱 Подключение клиентов

### QR-код готов!
- Файл: `shadowsocks_qr.png`
- Настройки: `shadowsocks_config.txt`

### 📱 Рекомендуемые приложения:

**🤖 Android:**
- [NekoBox](https://github.com/Matsuridayo/NekoBoxForAndroid/releases) ⭐
- [v2rayNG](https://github.com/2dust/v2rayNG/releases)

**🪟 Windows:**
- [v2rayN](https://github.com/2dust/v2rayN/releases) ⭐
- [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg/releases)
- [NekoRay](https://github.com/MatsuriDayo/nekoray/releases)

**🐧 Linux:**
- [v2rayA](https://github.com/v2rayA/v2rayA/releases) ⭐
- [Qv2ray](https://github.com/Qv2ray/Qv2ray/releases)
- [NekoRay](https://github.com/MatsuriDayo/nekoray/releases)

**🍎 iOS:**
- [Shadowrocket](https://apps.apple.com/app/shadowrocket/id932747118) ⭐ ($2.99)
- [OneClick](https://apps.apple.com/app/oneclick-safe-easy-fast/id1545555197) (Free)

**🍏 macOS:**
- [V2Box](https://apps.apple.com/app/v2box/id6446814690) ⭐
- [ClashX](https://github.com/yichengchen/clashX/releases)

## 🔧 Управление

```bash
./start.sh         # ▶️  Запуск
./stop.sh          # ⏹️  Остановка  
./status.sh        # 📊 Статус
./update_version.sh # 🔄 Обновление версии
```

## 🆘 Проблемы?

**Порт 443 занят:**
```bash
sudo systemctl stop nginx
./start.sh
```

**Docker не найден:**
```bash
sudo systemctl start docker
```

**Нет интернета:**
```bash
./stop.sh && ./start.sh
```

---

🎉 **Готово! Ваш VPN сервер работает!**
