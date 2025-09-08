#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Проверка и обновление версии XRay${NC}"
echo "====================================="

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
    local current_version=$(grep -o 'teddysun/xray:[0-9][0-9.]*' templates/docker-compose.yml.template | cut -d: -f2 2>/dev/null || echo "25.8.3")
    echo -e "${YELLOW}⚠️  Не удалось получить последнюю версию, используем текущую: $current_version${NC}"
    echo "$current_version"
}

# Функция для обновления версии в шаблонах
update_xray_version() {
    local new_version="$1"
    local current_version=$(grep -o 'teddysun/xray:[0-9][0-9.]*' templates/docker-compose.yml.template | cut -d: -f2 2>/dev/null || echo "25.8.3")
    
    if [[ "$new_version" != "$current_version" ]]; then
        echo -e "${YELLOW}🔄 Обновляю версию с $current_version на $new_version...${NC}"
        
        # Проверяем наличие файлов шаблонов
        if [[ ! -f "templates/docker-compose.yml.template" ]]; then
            echo -e "${RED}❌ Файл templates/docker-compose.yml.template не найден!${NC}"
            return 1
        fi
        
        if [[ ! -f "templates/config.json.template" ]]; then
            echo -e "${RED}❌ Файл templates/config.json.template не найден!${NC}"
            return 1
        fi
        
        # Создаем резервные копии
        cp templates/docker-compose.yml.template templates/docker-compose.yml.template.bak
        cp templates/config.json.template templates/config.json.template.bak
        
        # Обновляем docker-compose шаблон
        sed -i "s/teddysun\/xray:$current_version/teddysun\/xray:$new_version/g" templates/docker-compose.yml.template
        
        # Обновляем config.json шаблон
        sed -i "s/\"min\": \"$current_version\"/\"min\": \"$new_version\"/g" templates/config.json.template
        
        echo -e "${GREEN}✅ Версия обновлена в шаблонах${NC}"
        echo "📋 Обновленные файлы:"
        echo "   - templates/docker-compose.yml.template"
        echo "   - templates/config.json.template"
        echo "📁 Резервные копии:"
        echo "   - templates/docker-compose.yml.template.bak"
        echo "   - templates/config.json.template.bak"
        return 0
    else
        echo -e "${GREEN}✅ Версия $current_version уже актуальна${NC}"
        return 1
    fi
}

# Главная функция
main() {
    # Проверяем наличие curl
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}❌ curl не установлен!${NC}"
        echo "Установите его командой: sudo apt install -y curl"
        exit 1
    fi
    
    # Проверяем, что мы в правильной директории
    if [[ ! -d "templates" ]]; then
        echo -e "${RED}❌ Директория templates не найдена!${NC}"
        echo "Запустите скрипт из корня проекта"
        exit 1
    fi
    
    echo "📋 Текущие версии:"
    local current_docker=$(grep -o 'teddysun/xray:[0-9][0-9.]*' templates/docker-compose.yml.template | cut -d: -f2 2>/dev/null || echo "не найдена")
    local current_config=$(grep -o '"min": "[0-9][0-9.]*"' templates/config.json.template | cut -d'"' -f4 2>/dev/null || echo "не найдена")
    echo "   Docker Compose: $current_docker"
    echo "   Config JSON: $current_config"
    echo
    
    # Получаем последнюю версию
    local latest_version=$(get_latest_xray_version)
    echo
    
    # Обновляем версию
    if update_xray_version "$latest_version"; then
        echo
        echo -e "${GREEN}🎉 Обновление завершено!${NC}"
        echo
        echo "🔄 Следующие шаги:"
        echo "1. Остановите текущий сервер: ./stop.sh"
        echo "2. Перегенерируйте конфигурацию: ./generate.sh"  
        echo "3. Запустите сервер: ./start.sh"
        echo
        echo "📝 Или выполните все сразу:"
        echo "   ./stop.sh && ./generate.sh && ./start.sh"
    else
        echo
        echo "ℹ️  Никаких действий не требуется"
    fi
}

# Запускаем основную функцию
main "$@"
