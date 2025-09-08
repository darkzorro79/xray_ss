#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 Статус XRay сервера${NC}"
echo "======================"

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker не установлен!${NC}"
    exit 1
fi

# Проверяем наличие конфигурации
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Конфигурация не найдена!${NC}"
    echo "Сначала запустите: ./generate.sh"
    exit 1
fi

echo "🐳 Статус Docker контейнера:"
if docker ps | grep -q "xray"; then
    echo -e "${GREEN}✅ Контейнер запущен${NC}"
    echo
    echo "📋 Детали контейнера:"
    docker ps --filter "name=xray" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo
    
    echo "📈 Использование ресурсов:"
    docker stats xray --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    echo
    
    echo "📊 Последние 10 строк логов:"
    echo "----------------------------"
    docker logs xray --tail 10
    echo
    
    echo "🌐 Открытые порты:"
    echo "   - 443 (VLESS + Reality)"
    echo "   - 8080 (Shadowsocks UDP)"
    
else
    echo -e "${RED}❌ Контейнер не запущен${NC}"
    echo
    echo "🚀 Для запуска используйте:"
    echo "   ./start.sh"
fi

echo
echo "📁 Файлы конфигурации:"
if [ -f "shadowsocks_config.txt" ]; then
    echo -e "   ✅ shadowsocks_config.txt"
else
    echo -e "   ❌ shadowsocks_config.txt"
fi

if [ -f "shadowsocks_qr.png" ]; then
    echo -e "   ✅ shadowsocks_qr.png"
else
    echo -e "   ❌ shadowsocks_qr.png"
fi

if [ -f "xray/config.json" ]; then
    echo -e "   ✅ xray/config.json"
else
    echo -e "   ❌ xray/config.json"
fi

if [ -f "keys.txt" ]; then
    echo -e "   ✅ keys.txt"
else
    echo -e "   ❌ keys.txt"
fi
