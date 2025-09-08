# 📁 Структура проекта XRay Shadowsocks Template

```
new_xray/
├── 📜 generate.sh                 # Основной скрипт генерации конфигурации
├── 📜 start.sh                    # Скрипт запуска сервера
├── 📜 stop.sh                     # Скрипт остановки сервера  
├── 📜 status.sh                   # Скрипт проверки статуса
├── 📜 update_version.sh           # Скрипт обновления версии XRay
├── 📄 README.md                   # Подробная документация
├── 📄 QUICKSTART.md               # Быстрый старт за 3 минуты
├── 📄 INSTALL.md                  # Пошаговая инструкция установки
├── 📄 STRUCTURE.md                # Этот файл - описание структуры
├── 📄 LICENSE                     # MIT лицензия
├── 📄 .gitignore                  # Исключения для Git
├── 📁 templates/                  # Шаблоны конфигураций
│   ├── config.json.template       # Шаблон XRay конфигурации
│   ├── docker-compose.yml.template # Шаблон Docker Compose
│   └── shadowsocks_config.txt.template # Шаблон клиентской конфигурации
├── 📁 xray/                       # Папка для конфигураций XRay (создается автоматически)
└── 📁 scripts/                    # Дополнительные скрипты (пустая, для будущих расширений)
```

## 🔄 Файлы, создаваемые автоматически при генерации:

```
new_xray/ (после ./generate.sh)
├── docker-compose.yml             # Docker Compose конфигурация
├── shadowsocks_config.txt         # Инструкции для клиентов
├── shadowsocks_qr.png             # QR-код для подключения
├── keys.txt                       # Все сгенерированные ключи и пароли
└── xray/
    └── config.json                # Конфигурация XRay сервера
```

## 🔒 Файлы в .gitignore (не попадают в Git):

- `xray/config.json`
- `keys.txt`
- `shadowsocks_config.txt`
- `shadowsocks_qr.png`
- `docker-compose.yml`
- `*.log`, `logs/`
- Временные и IDE файлы

## 📝 Описание ключевых файлов:

### 🛠 Исполняемые скрипты:

- **`generate.sh`** - Главный скрипт. Запрашивает email и IP, генерирует все ключи и пароли, создает конфигурации из шаблонов
- **`start.sh`** - Запускает Docker контейнер с XRay, проверяет конфигурацию, показывает статус
- **`stop.sh`** - Останавливает контейнер, показывает статус
- **`status.sh`** - Показывает детальную информацию о работе сервера, логи, статистику

### 📋 Шаблоны:

- **`config.json.template`** - Шаблон конфигурации XRay с переменными {{UUID}}, {{EMAIL}} и т.д.
- **`docker-compose.yml.template`** - Шаблон для Docker контейнера
- **`shadowsocks_config.txt.template`** - Шаблон инструкций для клиентов

### 📖 Документация:

- **`README.md`** - Полная документация с описанием всех возможностей
- **`QUICKSTART.md`** - Быстрый старт за 3 минуты
- **`INSTALL.md`** - Подробная инструкция установки с решением проблем

## 🚀 Использование:

1. **Первоначальная настройка:**
   ```bash
   ./generate.sh
   ```

2. **Ежедневное использование:**
   ```bash
   ./start.sh    # Запуск
   ./stop.sh     # Остановка
   ./status.sh   # Проверка
   ```

3. **Смена ключей/пароля:**
   ```bash
   ./stop.sh
   ./generate.sh  # Новые данные
   ./start.sh
   ```

## 🔧 Расширения:

Для добавления новых функций используйте папку `scripts/` или создайте дополнительные шаблоны в `templates/`.

## 🐛 Логи и отладка:

```bash
# Логи контейнера
docker-compose logs -f

# Статус системы  
./status.sh

# Проверка конфигурации
python3 -m json.tool xray/config.json
```
