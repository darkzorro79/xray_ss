# 🚀 Пошаговая инструкция по установке

## 📋 Предварительные требования

### 1. Подготовка сервера
```bash
# Обновление системы
sudo apt update && sudo apt upgrade -y

# Установка необходимых пакетов
sudo apt install -y curl wget git qrencode python3

# Проверка открытых портов
sudo netstat -tlnp | grep -E ":(443|8080) "
```

### 2. Установка Docker
```bash
# Удаление старых версий (если есть)
sudo apt remove docker docker-engine docker.io containerd runc

# Установка зависимостей
sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release

# Добавление официального GPG ключа Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление репозитория
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Установка Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Добавление пользователя в группу docker
sudo usermod -aG docker $USER

# Перезагрузка для применения изменений группы
sudo reboot
```

### 3. Настройка файервола
```bash
# UFW (Ubuntu Firewall)
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 443
sudo ufw allow 8080
sudo ufw status

# Или iptables
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 8080 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

## 🛠 Установка шаблона

### 1. Клонирование проекта
```bash
cd /opt
sudo git clone https://github.com/ваш-username/xray-shadowsocks-template.git
sudo chown -R $USER:$USER xray-shadowsocks-template
cd xray-shadowsocks-template
```

### 2. Проверка прав на выполнение
```bash
chmod +x *.sh
ls -la *.sh
```

### 3. Генерация конфигурации
```bash
./generate.sh
```

**Что введите:**
- Email: ваш-email@example.com
- IP сервера: 1.2.3.4 (замените на ваш реальный IP)

### 4. Запуск сервиса
```bash
./start.sh
```

### 5. Проверка работы
```bash
./status.sh
```

## 📱 Настройка клиентов

### 🤖 NekoBox (Android) - Рекомендуется для Shadowsocks
1. Скачайте [NekoBox](https://github.com/Matsuridayo/NekoBoxForAndroid/releases) ⭐
2. Откройте приложение
3. Нажмите "+" → "Сканировать QR-код"
4. Отсканируйте файл `shadowsocks_qr.png`
5. Или скопируйте ссылку из `shadowsocks_config.txt`

### 🤖 v2rayNG (Android) - Универсальный
1. Скачайте [v2rayNG](https://github.com/2dust/v2rayNG/releases)
2. Нажмите "+" → "Импорт из QR-кода"
3. Отсканируйте QR-код или добавьте ссылку вручную

### 🪟 v2rayN (Windows) - Самый популярный
1. Скачайте [v2rayN](https://github.com/2dust/v2rayN/releases) ⭐
2. Запустите программу
3. Servers → Add Server → Import from QR code
4. Загрузите файл `shadowsocks_qr.png`

### 🪟 Clash for Windows - Удобный интерфейс
1. Скачайте [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg/releases)
2. Импортируйте конфигурацию через QR-код или ссылку

### 🐧 v2rayA (Linux) - Web интерфейс
1. Скачайте [v2rayA](https://github.com/v2rayA/v2rayA/releases) ⭐
2. Установите: `sudo dpkg -i v2raya_linux_x64_***.deb`
3. Запустите: `sudo systemctl enable --now v2raya`
4. Откройте http://localhost:2017 в браузере
5. Импортируйте конфигурацию через QR-код

### 🐧 Qv2ray (Linux) - GUI клиент
1. Скачайте [Qv2ray](https://github.com/Qv2ray/Qv2ray/releases)
2. Установите AppImage или deb пакет
3. Импортируйте конфигурацию через QR-код

## 🔧 Устранение проблем

### Проблема: "Permission denied" при запуске скриптов
```bash
chmod +x *.sh
```

### Проблема: Порт 443 занят (обычно nginx/apache)
```bash
# Проверить что использует порт
sudo netstat -tlnp | grep :443

# Остановить nginx
sudo systemctl stop nginx

# Или изменить порт в шаблоне на 8443
sed -i 's/"port": 443/"port": 8443/g' templates/config.json.template
sed -i 's/"443:443"/"8443:443"/g' templates/docker-compose.yml.template
```

### Проблема: Docker не найден
```bash
# Проверить установку
docker --version
docker-compose --version

# Переустановить Docker Compose
sudo apt install docker-compose-plugin
```

### Проблема: Нет доступа к интернету в контейнере
```bash
# Перезапуск Docker daemon
sudo systemctl restart docker

# Проверка DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

## 🔄 Регулярное обслуживание

### Еженедельно
```bash
# Проверка статуса
./status.sh

# Обновление системы
sudo apt update && sudo apt upgrade -y

# Очистка Docker
docker system prune -f
```

### Ежемесячно
```bash
# Обновление Docker образов
docker-compose pull
./stop.sh
./start.sh

# Ротация логов
docker-compose logs --tail 1000 > logs_backup.txt
```

### При необходимости смены ключей
```bash
./stop.sh
./generate.sh  # Введите новые данные
./start.sh
```

## 📊 Мониторинг производительности

### Простой мониторинг
```bash
# Скрипт проверки (можно добавить в cron)
cat > /opt/check_xray.sh << 'EOF'
#!/bin/bash
if ! docker ps | grep -q "xray"; then
    echo "XRay down at $(date)" >> /var/log/xray_monitor.log
    cd /opt/xray-shadowsocks-template && ./start.sh
fi
EOF

chmod +x /opt/check_xray.sh

# Добавить в crontab проверку каждые 5 минут
echo "*/5 * * * * /opt/check_xray.sh" | crontab -
```

### Продвинутый мониторинг
```bash
# Установка htop для мониторинга ресурсов
sudo apt install htop

# Мониторинг сети
sudo apt install iftop nethogs

# Использование:
htop                    # общий мониторинг системы
sudo iftop -i eth0      # сетевой трафик
sudo nethogs eth0       # трафик по процессам
```

## 🔐 Дополнительная безопасность

### Настройка SSH ключей (рекомендуется)
```bash
# На локальной машине генерируем ключ
ssh-keygen -t rsa -b 4096 -C "ваш-email@example.com"

# Копируем ключ на сервер
ssh-copy-id user@ваш-сервер

# Отключаем аутентификацию по паролю
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### Ограничение доступа
```bash
# Разрешить подключения только с определенных IP
sudo ufw allow from 192.168.1.0/24 to any port 22
sudo ufw deny 22
```

## 📈 Масштабирование

### Несколько пользователей
Отредактируйте `templates/config.json.template` и добавьте больше клиентов в массив `clients`:

```json
"clients": [
  {
    "id": "{{UUID1}}",
    "email": "{{EMAIL1}}",
    "flow": "xtls-rprx-vision"
  },
  {
    "id": "{{UUID2}}",
    "email": "{{EMAIL2}}",
    "flow": "xtls-rprx-vision"
  }
]
```

### Балансировка нагрузки
Для высоких нагрузок рассмотрите использование:
- nginx как прокси
- несколько инстансов XRay
- мониторинг через Prometheus/Grafana
