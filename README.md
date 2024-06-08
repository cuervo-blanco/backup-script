# Backup Script

This script copies all files from the specified source directory to a specified destination directory or to a backup folder in the current directory named after the source directory.

## Usage

```bash
./backup.sh [-s] source_directory [destination_directory]
```

## Options

- `-s`: Make the backup directory not hidden.
- `-help`: Display the help message and exit.

## Examples

1. **Basic usage**: Copy files from `source_directory` to a hidden backup directory in the current directory.

    ```bash
    ./backup.sh /path/to/source_directory
    ```

    This will create a hidden backup directory named `./.source_directory_backup` and copy the files there.

2. **Specify a destination directory**: Copy files from `source_directory` to a hidden backup directory in the specified destination directory.

    ```bash
    ./backup.sh /path/to/source_directory /path/to/destination_directory
    ```

    This will create a hidden backup directory named `/path/to/destination_directory/.source_directory_backup` and copy the files there.

3. **Non-hidden backup directory**: Use the `-s` flag to make the backup directory not hidden.

    ```bash
    ./backup.sh -s /path/to/source_directory
    ```

    This will create a backup directory named `./source_directory_backup` and copy the files there.

4. **Non-hidden backup directory with a specified destination**:

    ```bash
    ./backup.sh -s /path/to/source_directory /path/to/destination_directory
    ```

    This will create a backup directory named `/path/to/destination_directory/source_directory_backup` and copy the files there.

## Help

To display the help message, run:

```bash
./backup.sh -help
```

## Error Handling

- If the source directory does not exist, the script will output an error message and exit.
- If the destination directory is specified but does not exist, the script will output an error message and exit.

## Notes

- The default behavior is to create a hidden backup directory. Use the `-s` flag to create a non-hidden backup directory.
- The script requires at least one argument (the source directory) and can optionally take a second argument (the destination directory).

