FROM postgres:17

ENV AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_DEFAULT_REGION="us-east-1" \
    AWS_ENDPOINT="" \
    BACKUP_SCHEDULE="0 0 * * *" \
    BACKUP_BUCKET="backup" \
    BACKUP_PREFIX="postgres/%Y/%m/%d/postgres-" \
    BACKUP_SUFFIX="-%Y%m%d-%H%M.sql.gpg" \
    PGP_KEY="" \
    PGP_KEYSERVER="hkp://keys.gnupg.net"

#   POSTGRES_HOST POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB

RUN apt-get update
RUN apt-get install -y --no-install-recommends cron wget  \
    python3 python3-pip python3-setuptools python3-wheel

# install newest version of awscli - always
RUN pip3 install awscli --break-system-packages
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY README.md /
COPY *.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cron"]
