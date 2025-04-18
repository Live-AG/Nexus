# Nexus

[Репозиторий EDT](https://github.com/Live-AG/Nexus-EDT) - Стал приватным до выпуска релиза. Для доступа обращайтесь лично

Небольшая конфигурация для поддержания порядка в зоопарке баз. 

## Основные цели
Предоставить простой интерфейс для управления тестовыми информационными базами.
Для администраторов простой интерфейс для мониторинга и управления основными настройками кластера (по аналогии с консолью администрирования).
Пользователям (например Консультантам), разработчикам и подрядчикам дать возможность самостоятельно управлять тестовыми базами (Администраторы определяют доступные действия с базой, количество баз, время их жизни и квоты дискового пространства).

## Основные возможности

### Начало работы
1. Welcome screen
2. Помощник заполнения начальных настроек и данных

### Ведение справочной информации
1. Автоматическое получение описания кластера
	1. Справочник кластеров
2. Автоматическое формирование списка баз кластера
	1. Справочник баз
3. Ведение данных принадлежности базы к проекту
4. Хранение истории восстановления баз
5. Параметры актуальности базы
6. Ведение информации о конфигурациях
7. Ведение информации о хранилищах
8. Ведение информации о пользователях хранилища
9. Ведение информации о пользователях баз
	1. Механизм сопоставления пользователей разных баз
	2. Получение пользователей из AD
10. Хранение шаблонов Демо баз и конфигураций

### Управление
Все управление осуществляется по средствам исполнения скриптов объединенных в сценарии.
Скрипты не доступны для пользователей и подрядчиков.
#### Виды скриптов
1. Скрипты на OneScript/1С:Исполнитель
2. Скрипты на PowerShell/Bash

#### Стандартные сценарии
1. Создание новой базы пустой или Демо
2. Создание копии базы
3. Подключение к хранилищу
4. Замена имеющейся базы пустой или Демо
5. Разворачивание актуального бэкапа с параметрами (SQL)
6. Перенос базы на другой кластер
7. Обновление базы до типовой конфигурации
8. Блокировка и разблокировка входа в базу
9. Подготовка тестовой базы (произвоьлный сценарий)

### Мониторинг
1. Мониторинг состояния баз
2. Мониторинг состояния кластера
3. Мониторинг лицензий
4. Сбор статистики использование баз
5. Сбор статистики активности пользователей в базах
6. Мониторинг актуальных версий конфигураций
7. Сбор данных журналов регистрации во внешней базе ClickHouse
8. Мониторинг срока жизни тестовой базы
9. Мониторинг объема базы

### Прочие функции
1. Пути к каталогу обновлений и Демо
2. Пути к временным каталогам обмена (сетевым шарам)
3. Путь к каталогу административной установки
4. Автоматическое формирование файла списка баз
5. Управление базами СУБД при помощи скриптов
6. Разделение доступа и функционала по ролям профилям и группам

## Используемы технологии
Все технологии должны быть кроссплатформенные или на Linux
1. Сервер RAS и RAC (для управления кластером и базами)
3. Пакетный режим запуска Кнфигуратора/Предприятия
4. OneScript
5. GitLab (для хранения скриптов)
