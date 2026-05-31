## Запуск

```bash
docker compose up --build
```

В браузере:
- Магазин: http://localhost:3000
- Админка: http://localhost:3000/admin

## Учётные записи (seed)

| Роль      | Email                | Пароль       |
|-----------|----------------------|--------------|
| Админ     | admin@example.com    | admin123     |
| Менеджер  | manager@example.com  | manager123   |
| Покупатель| customer1@example.com| password12   |
| Покупатель| customer2@example.com| password12   |
| Покупатель| customer3@example.com| password12   |

## Команды

```bash
# Консоль Rails
docker compose exec web bin/rails console

# Миграции
docker compose exec web bin/rails db:migrate

# Сиды (заполнение БД демо-данными)
docker compose exec web bin/rails db:seed

# Пересоздать БД целиком
docker compose exec web bin/rails db:reset
```
