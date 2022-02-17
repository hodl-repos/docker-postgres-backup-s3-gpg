FROM postgres:14-alpine

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
# get latest ca-certificates
RUN update-ca-certificates

ENV AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_DEFAULT_REGION="" \
    AWS_ENDPOINT="" \
    BACKUP_SCHEDULE="0 0 * * *" \
    BACKUP_BUCKET="backup" \
    BACKUP_PREFIX="postgres/%Y/%m/%d/postgres-" \
    BACKUP_SUFFIX="-%Y%m%d-%H%M.sql.gpg" \
    PGP_KEY="" \
    PGP_KEYSERVER="hkp://keys.gnupg.net"

#   POSTGRES_HOST POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add py3-pip \
    && pip3 install --no-cache --upgrade pip setuptools \
    && pip3 install awscli \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && echo "Done."

COPY *.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cron"]
