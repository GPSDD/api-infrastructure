# MONGO BACKUPS
echo "start automongobackup"
/cronjobs/automongobackup.sh | true
# AWS SYNC
/root/.local/bin/aws s3 sync /cronjobs/backups/mongo s3://apihighways/db-backups/mongo
rm -rf /cronjobs/backups/mongo/*
echo "start autoelasticbackup"
/cronjobs/autoelasticbackup.sh
echo "autoelasticbackup finished"
