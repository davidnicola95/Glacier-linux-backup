#!/bin/bash

# Define variables
BUCKET="BUCKET"
DATE_TO_RETRIEVE="2023-10-05"  # Adjust this to the date of the backup you want to retrieve
TARGET_DIR="RESTORE-LOCATION"

echo "Starting retrieval process for date: $DATE_TO_RETRIEVE..."

# Fetch the backup and its hash from S3
echo "Fetching backup from S3..."
aws s3 cp s3://$BUCKET/$DATE_TO_RETRIEVE/backup_$DATE_TO_RETRIEVE.tar /tmp/
echo "Fetching hash from S3..."
aws s3 cp s3://$BUCKET/$DATE_TO_RETRIEVE/backup_$DATE_TO_RETRIEVE.tar.sha256 /tmp/

# Verify the hash
echo "Verifying data integrity using the hash..."
HASH_RETRIEVED=$(cat /tmp/backup_$DATE_TO_RETRIEVE.tar.sha256)
HASH_COMPUTED=$(sha256sum /tmp/backup_$DATE_TO_RETRIEVE.tar | awk '{print $1}')

if [ "$HASH_RETRIEVED" != "$HASH_COMPUTED" ]; then
    echo "Error: Data integrity check failed! Do not extract the backup."
    exit 1
fi

# Extract the backup
echo "Extracting the backup to $TARGET_DIR..."
tar xf /tmp/backup_$DATE_TO_RETRIEVE.tar -C $TARGET_DIR

# Optionally remove the downloaded backup files
echo "Cleaning up temporary files..."
rm /tmp/backup_$DATE_TO_RETRIEVE.tar /tmp/backup_$DATE_TO_RETRIEVE.tar.sha256

echo "Retrieval and extraction process completed!"
