# см. https://www.thepylot.dev/dockerizing-django-with-postgres-redis-and-celery/
FROM python:3.8-alpine
MAINTAINER B-or-is

# != 0, вывод Python без буферизации, в режиме реального времени
ENV PYTHONUNBUFFERED 1

# устанавливаем зависимости, копируя файл requirements.txt в образ докера
COPY ./requirements.txt /requirements.txt

# для взаимодействия с БД Postgres установим postgresql-client с помощью менеджера пакетов в alpine
# —update - обновление реестра перед его добавлением, —no-cache не сохраняет индекс реестра в файле докера
# эти параметры минимизируют количество дополнительных файлов и пакетов, добавляемых в наш док-контейнер
# это лучшая практика, т.к. она не включает никаких дополнительных зависимостей в системе,
# которые могут вызвать неожиданные побочные эффекты или создать уязвимости в системе безопасности.
# Параметр –virtual устанавливает псевдоним для зависимостей, который можем использовать, а затем легко
# удалить. Перечисляются все временные зависимости, необходимые для установки клиента Postgres.
#RUN apk add --update --no-cache postgresql-client jpeg-dev
#RUN apk add --update --no-cache --virtual .tmp-build-deps \
#    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
#RUN pip install -r /requirements.txt
#RUN apk del .tmp-build-deps

# Cоздаем пустой каталог с именем app на корневом уровне проекта.
# Создаем каталог в нашем образе Docker, который используем для хранения исходного кода нашего приложения
# и переключаемся на него в качестве каталога по умолчанию. Т.о., любое приложение, которое запускаем
# с помощью нашего контейнера докеров, будет запускаться из этого места.
# По сути, копируетcя каталог приложения с локального компьютера в контейнер докера.
RUN mkdir /app
COPY ./app /app
WORKDIR /app


##RUN adduser -d user
#RUN useradd --create-home user
#
#USER user