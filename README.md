# Setup
Make sure docker network is created.  Join any monitoring tools to this network to enable local connection:
> `docker network create p-net`

## ENV
Create .env with following env vars:
```
# aws
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=...

# postgres
POSTGRES_DATABASES=paideia
POSTGRES_HOST=...
POSTGRES_PORT=5432
POSTGRES_USER=...
POSTGRES_PASSWORD=...

```

## SQL
Run SQL files from /sql folder
