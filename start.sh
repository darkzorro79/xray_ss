#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Запуск XRay сервера${NC}"
echo "========================"

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker не установлен!${NC}"
    echo "Установите Docker и попробуйте снова."
    exit 1
fi

# Проверяем наличие конфигурации
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Конфигурация не найдена!${NC}"
    echo "Сначала запустите: ./generate.sh"
    exit 1
fi

if [ ! -f "xray/config.json" ]; then
    echo -e "${RED}❌ Конфигурация XRay не найдена!${NC}"
    echo "Сначала запустите: ./generate.sh"
    exit 1
fi

# Проверяем, не запущен ли уже контейнер
if docker ps | grep -q "xray"; then
    echo -e "${YELLOW}⚠️  Контейнер уже запущен!${NC}"
    echo "Для перезапуска сначала остановите его: ./stop.sh"
    exit 0
fi

echo "📋 Проверяю конфигурацию..."

# Проверяем синтаксис JSON конфигурации
if ! python3 -m json.tool xray/config.json > /dev/null 2>&1; then
    echo -e "${RED}❌ Ошибка в JSON конфигурации!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Конфигурация корректна${NC}"

# Запускаем контейнер
echo "🐳 Запускаю Docker контейнер..."

if docker-compose up -d; then
    echo
    echo -e "${GREEN}✅ XRay сервер успешно запущен!${NC}"
    echo
    echo "📊 Статус сервиса:"
    docker-compose ps
    echo
    echo "📋 Информация о подключении в файле: shadowsocks_config.txt"
    echo "🔳 QR-код для подключения: shadowsocks_qr.png"
    echo
    echo "📈 Для просмотра логов используйте:"
    echo "   docker-compose logs -f"
    echo
    echo "🛑 Для остановки используйте:"
    echo "   ./stop.sh"
    echo
    
    # Показываем порты
    echo "🌐 Открытые порты:"
    echo "   - 443 (VLESS + Reality)"
    echo "   - 8080 (Shadowsocks UDP)"
    
else
    echo -e "${RED}❌ Ошибка при запуске контейнера!${NC}"
    echo "Проверьте логи: docker-compose logs"
    exit 1
fi
