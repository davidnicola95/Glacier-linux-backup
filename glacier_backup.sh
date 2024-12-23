#!/bin/bash

# Directory to back up
DATA_DIR="DATADIR"

# Temporary directory for rsync
TEMP_DIR="TEMP"

# S3 bucket name
BUCKET="BUCKET"

# Current Date as folder name
DATE=$(date +'%Y-%m-%d')

echo "Starting backup for date: $DATE..."

ntfy publish \
    --title "Glacier Backup Started" \
    --tags loudspeaker \
    --priority default \
    NTFY_TOPIC \
    "Glacier backup has been initiated."

# Ensure the temporary directory exists
mkdir -p $TEMP_DIR

# Rsync the data to the temporary directory with progress percentage
echo "Syncing data to temporary directory..."
rsync -a --info=progress2 $DATA_DIR/ $TEMP_DIR/

# Create tarball without compression
TAR_NAME="/mnt/datastore/backup_$DATE.tar"
echo "Creating tarball of $TEMP_DIR into $TAR_NAME..."
tar cf $TAR_NAME -C $TEMP_DIR .

# Compute the hash
echo "Computing hash for $TAR_NAME..."
HASH=$(sha256sum $TAR_NAME | awk '{print $1}')
echo "Hash computed: $HASH"
echo $HASH > $TAR_NAME.sha256

# Upload to the S3 bucket
echo "Uploading $TAR_NAME to S3 bucket $BUCKET..."
aws s3 cp $TAR_NAME s3://$BUCKET/$DATE/backup_$DATE.tar
echo "Uploading hash to S3 bucket $BUCKET..."
aws s3 cp $TAR_NAME.sha256 s3://$BUCKET/$DATE/backup_$DATE.tar.sha256

# Remove local copies and temporary directory
echo "Removing local copies and temporary directory..."
rm -rf $TAR_NAME $TAR_NAME.sha256 $TEMP_DIR

echo "Backup process completed!"

ntfy publish \
    --title "Glacier Backup Completed" \
    --tags loudspeaker \
    --priority default \
    NTFY_TOPIC \
    "Glacier backup has been completed."
