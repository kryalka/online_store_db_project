СОДЕРЖАНИЕ:
1. create_database.sql     - SQL-скрипт создания всех объектов БД с комментариями
2. online_store_backup.sql - Резервная копия БД (pg_dump)
3. online_store_report.pdf - Полный отчет (диаграммы + результаты запросов)
4. queries/               - 5 сложных SQL-запросов
5. er_diagrams/           - ER-диаграммы

ИНСТРУКЦИЯ:
1. Восстановить БД: psql -U postgres -f online_store_backup.sql
2. Или создать заново: psql -U postgres -d online_store -f create_database.sql
3. Проверить запросы: psql -U postgres -d online_store -f queries/01_top_products.sql

ВЫПОЛНЕННЫЕ ТРЕБОВАНИЯ:
✓ 10 таблиц (8-10)
✓ 4 триггера (min 2)  
✓ 2 хранимые функции (min 2)
✓ 5 сложных запросов (min 5)
✓ JOIN в 3+ запросах
✓ Подзапрос EXISTS
✓ CTE (WITH)
✓ Оконные функции (RANK, LAG, SUM OVER)
