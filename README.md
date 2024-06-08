# Backup Script

This is a simple Bash script to back up files from a specified source directory to a destination directory or a backup folder in the current directory. The backup folder can be named with a timestamp, hidden, or updated from a previous backup.

## Usage

```bash
./backup.sh [-s] [-t] [-u] source_directory [destination_directory]
```

## Description

This script copies all files from the specified source directory to the specified destination directory or to a backup folder in the current directory named after the source directory.

## Options

- `-s` : Make the backup directory not hidden.
- `-t` : Add a timestamp to the backup directory name.
- `-u` : Update the existing backup directory.
- `-tu` : Timestamp and update the latest backup.
- `-help` : Display the help message and exit.

## Examples

1. Basic usage with a source directory:
    ```bash
    ./backup.sh /path/to/source
    ```

2. Specifying a destination directory:
    ```bash
    ./backup.sh /path/to/source /path/to/destination
    ```

3. Adding a timestamp to the backup directory name:
    ```bash
    ./backup.sh -t /path/to/source
    ```

4. Creating a non-hidden backup directory:
    ```bash
    ./backup.sh -s /path/to/source
    ```

5. Updating the latest backup:
    ```bash
    ./backup.sh -u /path/to/source
    ```

## Notes

- The script will create a hidden backup directory by default. Use the `-s` option to make it visible.
- If the `-t` option is used, a timestamp will be appended to the backup directory name.
- If the `-u` option is used, the script will find the most recent backup and update it.
- The `-help` option provides usage information and exits.

## Script Details

### display_help()

Displays the usage information.

### perform_backup()

Performs the actual backup operation. Uses `rsync` if updating an existing backup, otherwise uses `cp` to copy files.

### Main Execution Flow

1. Parse options (`-s`, `-t`, `-u`).
2. Validate source and destination directories.
3. Determine the backup directory name based on options.
4. Create the backup directory if it does not exist.
5. Log the start of the backup operation.
6. Perform the backup using `perform_backup`.
7. Rename the backup directory if needed.
8. Log the completion of the backup operation.

## License

This script is provided as-is without any warranty. Use it at your own risk.

## Author

Jaime Osvaldo

