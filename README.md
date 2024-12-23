# Glacier Backup and Restore Scripts

## Overview
This project provides two Bash scripts to facilitate backing up and restoring data using AWS S3 Glacier storage. These scripts streamline the process of archiving, hashing, uploading, and retrieving backups while ensuring data integrity through hash verification.

## Features
### Glacier Backup Script
- Syncs specified directories to a temporary location using `rsync`.
- Creates an uncompressed tarball of the data for efficient storage.
- Computes a SHA256 hash of the tarball to ensure data integrity.
- Uploads the tarball and its corresponding hash to an AWS S3 bucket.

### Glacier Restore Script
- Downloads a backup tarball and its hash from an AWS S3 bucket.
- Verifies the integrity of the downloaded tarball using the hash.
- Extracts the tarball to a specified directory after successful verification.

## Requirements
- **AWS CLI** configured with appropriate permissions to access the target S3 bucket.
- Required system tools:
  - `rsync`
  - `tar`
  - `sha256sum`
- An AWS S3 bucket configured to use Glacier storage class for cost-effective long-term archiving.

## Usage
### Backup Script
1. Configure the following variables in `glacier_backup.sh`:
   - `DATA_DIR`: The directory to back up.
   - `TEMP_DIR`: The temporary location to stage the data.
   - `BUCKET`: The name of the target S3 bucket.

2. Run the script:
   ```bash
   ./glacier_backup.sh
   ```

3. The script will:
   - Sync data to the temporary directory.
   - Create a tarball of the synced data.
   - Compute and save a hash for the tarball.
   - Upload the tarball and hash to the S3 bucket.
   - Clean up local files and temporary directories.

### Restore Script
1. Configure the following variables in `glacier_pull.sh`:
   - `BUCKET`: The name of the S3 bucket.
   - `DATE_TO_RETRIEVE`: The date of the backup to retrieve (e.g., `2023-10-05`).
   - `TARGET_DIR`: The directory where the backup will be restored.

2. Run the script:
   ```bash
   ./glacier_pull.sh
   ```

3. The script will:
   - Download the tarball and its hash from the S3 bucket.
   - Verify the integrity of the tarball using the hash.
   - Extract the tarball to the target directory.

## Example
### Backup
Suppose you want to back up `/home/data` to an S3 bucket named `my-backup-bucket`:
1. Set `DATA_DIR` to `/home/data`, `TEMP_DIR` to `/tmp/data-backup`, and `BUCKET` to `my-backup-bucket`.
2. Run the script:
   ```bash
   ./glacier_backup.sh
   ```

### Restore
To restore a backup from `2023-10-05` to `/home/restore`:
1. Set `BUCKET` to `my-backup-bucket`, `DATE_TO_RETRIEVE` to `2023-10-05`, and `TARGET_DIR` to `/home/restore`.
2. Run the script:
   ```bash
   ./glacier_pull.sh
   ```

## Security Notes
- Ensure your AWS credentials are securely configured using environment variables or AWS IAM roles.
- The tarball and its hash are temporarily stored on disk during the backup and restore processes. Use secure directories for temporary storage.
- Delete temporary files promptly to minimize exposure.

## Contributions
Contributions are welcome to improve these scripts! Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Disclaimer
These scripts are provided as-is without warranty of any kind. Use them at your own risk and ensure compliance with your organization's backup policies.

