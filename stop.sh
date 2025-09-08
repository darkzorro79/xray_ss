#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}🛑 Остановка XRay сервера${NC}"
echo "========================="

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker не установлен!${NC}"
    exit 1
fi

# Проверяем наличие docker-compose.yml
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ docker-compose.yml не найден!${NC}"
    exit 1
fi

# Проверяем, запущен ли контейнер
if ! docker ps | grep -q "xray"; then
    echo -e "${YELLOW}⚠️  Контейнер не запущен${NC}"
    echo "Нечего останавливать."
    exit 0
fi

echo "🔄 Останавливаю контейнер..."

# Останавливаем и удаляем контейнер
if docker-compose down; then
    echo
    echo -e "${GREEN}✅ XRay сервер успешно остановлен!${NC}"
    echo
    
    # Проверяем, что контейнер действительно остановлен
    if docker ps | grep -q "xray"; then
        echo -e "${YELLOW}⚠️  Контейнер все еще работает${NC}"
        echo "Принудительная остановка..."
        docker stop xray 2>/dev/null
        docker rm xray 2>/dev/null
    fi
    
    echo "📊 Статус сервисов:"
    docker-compose ps
    echo
    echo "🚀 Для запуска используйте:"
    echo "   ./start.sh"
    
else
    echo -e "${RED}❌ Ошибка при остановке контейнера!${NC}"
    echo "Попробуйте принудительную остановку:"
    echo "   docker stop xray && docker rm xray"
    exit 1
fi
