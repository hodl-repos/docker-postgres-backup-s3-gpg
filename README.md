# Backup PostgreSQL Database to S3/Minio

**this repository is on hodl by us so oneone can delete it (now with psql 14)**

TLDR: 
> https://github.com/hodl-repos/docker-postgres-backup-s3-gpg/pkgs/container/docker-postgres-backup-s3-gpg

This docker image backup and encrypt PostgreSQL database to S3/Minio periodically.

## Usage

### Backup to S3

    docker run -d --restart unless-stopped \
           --name postgres_backup \
           -e AWS_ACCESS_KEY_ID="your-access-key" \
           -e AWS_SECRET_ACCESS_KEY="your-secret-access-keys" \
           -e PGP_KEY=YOUR_PGP_PUBLIC_KEY \
           -e BACKUP_SCHEDULE="0 * * * *" \
           -e POSTGRES_DB=your-dbname \
           -e POSTGRES_HOST=your-postgres-container \
           -e POSTGRES_USER=your-postgres-username \
           -e POSTGRES_PASSWORD="your-postgres-password" \
           --network your-network \
           chaifeng/postgres-backup-s3-gpg

### Backup to your own Minio server

    docker run -d --restart unless-stopped \
           --name postgres_backup \
           -e AWS_ENDPOINT="https://your.minio.server.example.com" \
           -e AWS_ACCESS_KEY_ID="your-access-key" \
           -e AWS_SECRET_ACCESS_KEY="your-secret-access-keys" \
           -e PGP_KEY=YOUR_PGP_PUBLIC_KEY \
           -e BACKUP_SCHEDULE="0 * * * *" \
           -e POSTGRES_DB=your-dbname \
           -e POSTGRES_HOST=your-postgres-container \
           -e POSTGRES_USER=root \
           -e POSTGRES_PASSWORD="your-postgres-password" \
           --network your-network \
           chaifeng/postgres-backup-s3-gpg

### Use a local PGP public key file

    docker run -d --restart unless-stopped \
           --name postgres_backup \
           -e AWS_ACCESS_KEY_ID="your-access-key" \
           -e AWS_SECRET_ACCESS_KEY="your-secret-access-keys" \
           -v /path/to/your/pgp-key.txt:/pgp.txt \
           -e PGP_KEY=/pgp.txt \
           -e BACKUP_SCHEDULE="0 * * * *" \
           -e POSTGRES_DB=your-dbname \
           -e POSTGRES_HOST=your-postgres-container \
           -e POSTGRES_USER=your-postgres-username \
           -e POSTGRES_PASSWORD="your-postgres-password" \
           --network your-network \
           chaifeng/postgres-backup-s3-gpg

### Use a remote PGP public key file

    docker run -d --restart unless-stopped \
           --name postgres_backup \
           -e AWS_ACCESS_KEY_ID="your-access-key" \
           -e AWS_SECRET_ACCESS_KEY="your-secret-access-keys" \
           -e PGP_KEY=https://exaple.com/pgp-key.txt \
           -e BACKUP_SCHEDULE="0 * * * *" \
           -e POSTGRES_DB=your-dbname \
           -e POSTGRES_HOST=your-postgres-container \
           -e POSTGRES_USER=your-postgres-username \
           -e POSTGRES_PASSWORD="your-postgres-password" \
           chaifeng/postgres-backup-s3-gpg

## Variables

- `AWS_ACCESS_KEY_ID`
  Access Key
- `AWS_SECRET_ACCESS_KEY`
  Securet Access Key
- `PGP_KEY`
  Your PGP public key ID, used to encrypt your backups
- `POSTGRES_HOST`
  the host/ip of your postgres database
- `POSTGRES_DB`
  the database name to dump.
- `POSTGRES_USER`
  the username of your postgres database
- `POSTGRES_PASSWORD`
  the password of your postgres database

### Optional variables
- `AWS_DEFAULT_REGION`
  `us-east-1` by default
- `AWS_ENDPOINT`
  Customize this variable if you are using Minio, the url of your Minio server
- `PGP_KEYSERVER`
  the PGP key server used to retrieve you PGP public key
- `BACKUP_SCHEDULE`
  the interval of cron job to run postgresdump. `0 0 * * *` by default
- `BACKUP_BUCKET`
  the bucket of your S3/Minio
- `BACKUP_PREFIX`
  the default value is `postgres/%Y/%m/%d/postgres-`, please see the strftime(3) manual page
- `BACKUP_SUFFIX`
  the default value is `-%Y%m%d-%H%M.sql.gz.gpg`, please see the strftime(3) manual page

## Decrypt

    gpg --decrypt your-backup.gpg

    aws s3 cp s3://your-bucket/path/to/your/backup.gpg - | gpg --output backup.sql --decrypt

    mc cat minio/your-bucket/path/to/your/backup.gpg | gpg --output backup.sql --decrypt
