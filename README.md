# XRay с Shadowsocks - Шаблон для автоматической настройки

🚀 **Автоматический шаблон для развертывания XRay с поддержкой Shadowsocks и VLESS Reality**

## 📋 Описание

Этот проект представляет собой готовый шаблон для быстрого развертывания XRay сервера с поддержкой:
- **Shadowsocks** с шифрованием 2022-blake3-aes-128-gcm
- **VLESS** протокол с Reality маскировкой
- **UDP** трафик для игр и видеозвонков
- Автоматическая генерация конфигураций
- QR-коды для быстрого подключения

## 🛠 Требования

- Ubuntu/Debian сервер с root доступом
- Docker и Docker Compose
- Открытые порты: 443, 8080
- Пакет qrencode для генерации QR-кодов

## 🚀 Быстрый старт

### 1. Клонирование репозитория
```bash
git clone https://github.com/ваш-username/xray-shadowsocks-template.git
cd xray-shadowsocks-template
```

### 2. Установка зависимостей
```bash
# На Ubuntu/Debian
sudo apt update
sudo apt install -y qrencode

# Установка Docker (если не установлен)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### 3. Генерация конфигурации
```bash
./generate.sh
```
Скрипт попросит ввести:
- 📧 Ваш email
- 🌐 IP адрес сервера

### 4. Запуск сервера
```bash
./start.sh
```

### 5. Проверка статуса
```bash
./status.sh
```

## 📱 Подключение клиентов

После генерации конфигурации вы получите:

- `shadowsocks_config.txt` - инструкции по подключению
- `shadowsocks_qr.png` - QR-код для быстрого подключения
- `keys.txt` - все сгенерированные ключи и пароли

### Рекомендуемые клиенты:

**🤖 Android:**
- [NekoBox](https://github.com/Matsuridayo/NekoBoxForAndroid/releases) - Лучший для Shadowsocks ⭐
- [v2rayNG](https://github.com/2dust/v2rayNG/releases) - Универсальный клиент
- [SagerNet](https://github.com/SagerNet/SagerNet/releases) - Альтернатива

**🍎 iOS:**
- [Shadowrocket](https://apps.apple.com/app/shadowrocket/id932747118) - $2.99, лучший выбор ⭐
- [Quantumult X](https://apps.apple.com/app/quantumult-x/id1443988620) - $7.99, продвинутый
- [OneClick](https://apps.apple.com/app/oneclick-safe-easy-fast/id1545555197) - Бесплатный

**🪟 Windows:**
- [v2rayN](https://github.com/2dust/v2rayN/releases) - Самый популярный ⭐
- [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg/releases) - Удобный интерфейс
- [Qv2ray](https://github.com/Qv2ray/Qv2ray/releases) - Open Source
- [NekoRay](https://github.com/MatsuriDayo/nekoray/releases) - Современный

**🐧 Linux:**
- [v2rayA](https://github.com/v2rayA/v2rayA/releases) - Web интерфейс ⭐
- [Qv2ray](https://github.com/Qv2ray/Qv2ray/releases) - GUI клиент
- [NekoRay](https://github.com/MatsuriDayo/nekoray/releases) - Кросс-платформенный
- Command line: `xray` напрямую

**🍏 macOS:**
- [V2Box](https://apps.apple.com/app/v2box/id6446814690) - App Store ⭐
- [ClashX](https://github.com/yichengchen/clashX/releases) - Популярный
- [Qv2ray](https://github.com/Qv2ray/Qv2ray/releases) - Open Source

## 🎛 Управление сервером

### Основные команды:
```bash
./start.sh         # Запуск сервера
./stop.sh          # Остановка сервера
./status.sh        # Проверка статуса
./update_version.sh # Проверка и обновление версии XRay
```

### Просмотр логов:
```bash
docker-compose logs -f
```

### Перегенерация конфигурации:
```bash
./stop.sh
./generate.sh
./start.sh
```

## 🔧 Структура проекта

```
xray-shadowsocks-template/
├── 📁 templates/              # Шаблоны конфигураций
│   ├── config.json.template   # Шаблон XRay конфигурации
│   ├── docker-compose.yml.template
│   └── shadowsocks_config.txt.template
├── 📁 xray/                   # Конфигурации XRay (создается автоматически)
├── 📜 generate.sh             # Скрипт генерации конфигурации
├── 📜 start.sh                # Скрипт запуска
├── 📜 stop.sh                 # Скрипт остановки
├── 📜 status.sh               # Скрипт проверки статуса
├── 📄 README.md               # Этот файл
└── 📄 .gitignore              # Исключения для Git
```

## 🔒 Безопасность

⚠️ **ВАЖНО:**
- Все секретные данные (ключи, пароли) автоматически добавляются в `.gitignore`
- Никогда не публикуйте файлы `keys.txt`, `config.json` или `shadowsocks_config.txt`
- Регулярно обновляйте пароли и ключи
- Используйте strong пароли для сервера

## 🌐 Сетевые настройки

### Открываемые порты:
- **443** - VLESS с Reality маскировкой
- **8080** - Shadowsocks (TCP/UDP)

### Firewall настройки:
```bash
# UFW
sudo ufw allow 443
sudo ufw allow 8080

# iptables
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 8080 -j ACCEPT
```

## 🐛 Устранение проблем

### Проблема: Контейнер не запускается
```bash
# Проверьте логи
docker-compose logs

# Проверьте конфигурацию
python3 -m json.tool xray/config.json
```

### Проблема: Порты заняты
```bash
# Проверьте, что использует порты
sudo netstat -tlnp | grep -E ":(443|8080) "

# Остановите конфликтующие сервисы
sudo systemctl stop nginx  # если используется nginx на 443
```

### Проблема: Нет интернета в контейнере
```bash
# Перезапустите Docker
sudo systemctl restart docker

# Проверьте DNS
docker exec xray nslookup google.com
```

## 📊 Мониторинг

### Основные метрики:
```bash
# Статистика Docker контейнера
docker stats xray

# Использование портов
ss -tlnp | grep -E ":(443|8080) "

# Логи в реальном времени
docker-compose logs -f --tail 50
```

## 🔄 Обновление

### Автоматическое обновление XRay:
```bash
# Проверка и обновление до последней версии
./update_version.sh

# Применение обновлений
./stop.sh && ./generate.sh && ./start.sh
```

### Ручное обновление XRay:
1. Измените версию в `templates/docker-compose.yml.template`
2. Перегенерируйте конфигурацию: `./generate.sh`
3. Перезапустите: `./stop.sh && ./start.sh`

### Обновление шаблона проекта:
```bash
git pull origin main
# Проверьте изменения в шаблонах и перегенерируйте при необходимости
```

### Автоматическая проверка версий:
При запуске `./generate.sh` автоматически проверяется последняя версия XRay и предлагается обновление.

## 🤝 Вклад в проект

1. Fork проекта
2. Создайте feature ветку (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для подробностей.

## ⭐ Поддержка

Если проект оказался полезным, поставьте ⭐ на GitHub!

## 📞 Связь

- Создайте [Issue](https://github.com/ваш-username/xray-shadowsocks-template/issues) для сообщения о багах
- Обсуждения в [Discussions](https://github.com/ваш-username/xray-shadowsocks-template/discussions)

---

**🛡 Используйте ответственно и в соответствии с законами вашей страны**
