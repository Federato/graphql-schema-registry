#!/bin/sh

until psql $DATABASE_URL -c '\l'; do
    >&2 echo "Postgres is not up right now - Waiting..."
    sleep 1
done

>&1 echo "Postgres is up - moving on"

if [ "$DJANGO_MANAGEPY_MIGRATE" = 'on' ]; then
    python manage.py migrate --noinput
    python manage.py loaddata operations
fi

exec "$@"