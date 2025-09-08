#!/bin/bash

# Функция для проверки установленных зависимостей
check_dependencies() {
    local deps=("docker" "base64" "qrencode" "curl")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo "❌ Отсутствуют зависимости: ${missing[*]}"
        echo "Установите их командой:"
        echo "sudo apt update && sudo apt install -y qrencode curl"
        if [[ " ${missing[*]} " =~ " docker " ]]; then
            echo "Для Docker следуйте инструкции: https://docs.docker.com/engine/install/"
        fi
        exit 1
    fi
}

# Функция для получения последней версии XRay из Docker Hub
get_latest_xray_version() {
    echo "🔍 Проверяю последнюю версию XRay..."
    
    # Получаем список тегов с Docker Hub API
    local api_url="https://registry.hub.docker.com/v2/repositories/teddysun/xray/tags/?page_size=100"
    local latest_version=""
    
    # Пытаемся получить версии через API
    if latest_version=$(curl -s "$api_url" | grep -o '"name":"[0-9][0-9.]*"' | sed 's/"name":"//g; s/"//g' | sort -V | tail -1 2>/dev/null); then
        if [[ -n "$latest_version" && "$latest_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "✅ Найдена последняя версия: $latest_version"
            echo "$latest_version"
            return 0
        fi
    fi
    
    # Fallback - возвращаем текущую версию из шаблона
    local current_version=$(grep -o 'teddysun/xray:[0-9][0-9.]*' templates/docker-compose.yml.template | cut -d: -f2)
    echo "⚠️  Не удалось получить последнюю версию, используем текущую: $current_version"
    echo "$current_version"
}

# Функция для обновления версии в шаблонах
update_xray_version() {
    local new_version="$1"
    local current_version=$(grep -o 'teddysun/xray:[0-9][0-9.]*' templates/docker-compose.yml.template | cut -d: -f2)
    
    if [[ "$new_version" != "$current_version" ]]; then
        echo "🔄 Обновляю версию с $current_version на $new_version..."
        
        # Обновляем docker-compose шаблон
        sed -i "s/teddysun\/xray:$current_version/teddysun\/xray:$new_version/g" templates/docker-compose.yml.template
        
        # Обновляем config.json шаблон
        sed -i "s/\"min\": \"$current_version\"/\"min\": \"$new_version\"/g" templates/config.json.template
        
        echo "✅ Версия обновлена в шаблонах"
        return 0
    else
        echo "✅ Версия $current_version уже актуальна"
        return 1
    fi
}

# Функция генерации UUID
generate_uuid() {
    if command -v uuidgen &> /dev/null; then
        uuidgen
    else
        # Fallback для систем без uuidgen
        cat /proc/sys/kernel/random/uuid
    fi
}

# Функция генерации x25519 ключей
generate_x25519() {
    # Генерируем приватный ключ (32 байта в base64)
    local private_key=$(openssl rand -base64 32 | tr -d '\n')
    echo "$private_key"
}

# Функция генерации пароля для Shadowsocks
generate_ss_password() {
    # Генерируем 16 байт для AES-128
    openssl rand -base64 16 | tr -d '\n'
}

# Функция создания SS URL
create_ss_url() {
    local password="$1"
    local server_ip="$2"
    local port="8080"
    local method="2022-blake3-aes-128-gcm"
    
    # Кодируем метод:пароль в base64
    local auth=$(echo -n "${method}:${password}" | base64 | tr -d '\n')
    
    # Создаем URL
    echo "ss://${auth}@${server_ip}:${port}#XRay-SS-UDP"
}

# Основная функция
main() {
    echo "🚀 Генератор конфигурации XRay с Shadowsocks"
    echo "=============================================="
    echo
    
    # Проверяем зависимости
    check_dependencies
    
    # Проверяем и обновляем версию XRay
    echo
    local latest_version=$(get_latest_xray_version)
    if update_xray_version "$latest_version"; then
        echo "ℹ️  Будет использована обновленная версия: $latest_version"
    fi
    echo
    
    # Запрашиваем email
    while true; do
        read -p "📧 Введите ваш email: " email
        if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            echo "❌ Неверный формат email. Попробуйте снова."
        fi
    done
    
    # Запрашиваем IP сервера
    while true; do
        read -p "🌐 Введите IP адрес вашего сервера: " server_ip
        if [[ "$server_ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            break
        else
            echo "❌ Неверный формат IP адреса. Попробуйте снова."
        fi
    done
    
    echo
    echo "🔄 Генерирую ключи и пароли..."
    
    # Генерируем все необходимые данные
    UUID=$(generate_uuid)
    PRIVATE_KEY=$(generate_x25519)
    SS_PASSWORD=$(generate_ss_password)
    SS_URL=$(create_ss_url "$SS_PASSWORD" "$server_ip")
    
    echo "✅ Данные сгенерированы:"
    echo "   UUID: $UUID"
    echo "   Email: $email"
    echo "   Server IP: $server_ip"
    echo "   Private Key: $PRIVATE_KEY"
    echo "   SS Password: $SS_PASSWORD"
    echo
    
    # Создаем конфигурационные файлы
    echo "📝 Создаю конфигурационные файлы..."
    
    # Заменяем переменные в шаблонах
    sed -e "s/{{UUID}}/$UUID/g" \
        -e "s/{{EMAIL}}/$email/g" \
        -e "s/{{PRIVATE_KEY}}/$PRIVATE_KEY/g" \
        -e "s/{{SS_PASSWORD}}/$SS_PASSWORD/g" \
        templates/config.json.template > xray/config.json
    
    cp templates/docker-compose.yml.template docker-compose.yml
    
    sed -e "s|{{SS_URL}}|$SS_URL|g" \
        -e "s/{{SERVER_IP}}/$server_ip/g" \
        -e "s/{{SS_PASSWORD}}/$SS_PASSWORD/g" \
        templates/shadowsocks_config.txt.template > shadowsocks_config.txt
    
    # Создаем QR код
    echo "🔳 Генерирую QR-код..."
    echo "$SS_URL" | qrencode -o shadowsocks_qr.png -s 10 -m 2
    
    # Сохраняем ключи для справки
    cat > keys.txt << EOF
Сгенерированные ключи и пароли
=============================

UUID: $UUID
Email: $email
Server IP: $server_ip
Private Key: $PRIVATE_KEY
Shadowsocks Password: $SS_PASSWORD

Shadowsocks URL: $SS_URL

Дата генерации: $(date)
EOF
    
    echo
    echo "🎉 Конфигурация успешно создана!"
    echo "📁 Созданные файлы:"
    echo "   ├── docker-compose.yml"
    echo "   ├── xray/config.json"
    echo "   ├── shadowsocks_config.txt"
    echo "   ├── shadowsocks_qr.png        🔳 QR-код для быстрого подключения!"
    echo "   └── keys.txt"
    echo
    echo "📱 QR-код готов для сканирования:"
    echo "   Файл: shadowsocks_qr.png"
    echo "   Откройте его в любом просмотрщике изображений"
    echo
    echo "🔗 Ссылка для ручного подключения:"
    echo "   $SS_URL"
    echo
    echo "📋 Рекомендуемые VPN-клиенты:"
    echo "   🤖 Android: NekoBox, v2rayNG"
    echo "   🪟 Windows: v2rayN, Clash for Windows"
    echo "   🐧 Linux: v2rayA, Qv2ray"
    echo "   🍎 iOS: Shadowrocket, Quantumult X"
    echo "   🍏 macOS: V2Box, ClashX"
    echo
    echo "🚀 Для запуска сервиса используйте:"
    echo "   ./start.sh"
    echo
    echo "🛑 Для остановки сервиса используйте:"
    echo "   ./stop.sh"
}

# Запускаем основную функцию
main "$@"
