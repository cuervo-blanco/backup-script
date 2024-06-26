#!/bin/bash

# Function to display the usage of the program
function display_help() {
    echo "Usage: $0 [-s] [-t] [-u] source_directory [destination_directory]"
    echo ""
    echo "This script copies all files from the specified source directory"
    echo "to the specified destination directory or to a backup folder"
    echo "in the current directory named after the source directory."
    echo ""
    echo "Options:"
    echo " -s       Make the backup directory not hidden"
    echo " -t       Add a timestamp to the backup directory name"
    echo " -u       Update the existing backup directory"
    echo " -tu      Timestamp and update the latest backup"
    echo " -help    Display this help message and exit"
}

# Check for the -help flag
if [ "$1" == "-help" ]; then
    display_help
    exit 0
fi

# Initialize variables
HIDDEN=true
TIMESTAMP=false
UPDATE=false
SOURCE_DIR=""
DEST_DIR=""
BASE_DIR=""

# Parse options
while getopts ":stu" opt; do
    case ${opt} in
        s )
            HIDDEN=false
            ;;
        t )
            TIMESTAMP=true
            ;;
        u )
            UPDATE=true
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            display_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 [-s] [-t] [-u] source directory [destination_directory]"
    echo "Type $0 -help for more information"
    exit 1
fi

# Source directory from the argument
SOURCE_DIR=$1

# Destination directory form the second argument or default to .backup
if [ "$#" -eq 2 ]; then
    BASE_DIR="$2"
else
    BASE_DIR="."
fi

# Check if the source directory is valid
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Check if the destination directory is valid
if [ "$#" -eq 2 ] && [ ! -d "$BASE_DIR" ]; then
    echo "Error: Destination directory '$DEST_DIR' does not exist."
    exit 1
fi

BASENAME=$(basename "$SOURCE_DIR")
if $HIDDEN; then
    BACKUP_DIR="$BASE_DIR/.$BASENAME"_backup
else
    BACKUP_DIR="$BASE_DIR/$BASENAME"_backup
fi

# Handle timestamp
if [ $TIMESTAMP ]; then
    TIMESTAMP=$(date +V%y%m%d-T%H%M%S)
    BACKUP_DIR="${BACKUP_DIR}_$TIMESTAMP"
fi

# Find the most recent backup
if $UPDATE; then
    LATEST_BACKUP=$(find "$BASE_DIR" -type d -name "$BASENAME"_backup\* | sort -r | head -n 1)
    if [ -z "$LATEST_BACKUP" ]; then
        echo "No  previous backup found to update."
        exit 1
    fi
    BACKUP_DIR=$LATEST_BACKUP
fi

# Create the .backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Log file inside the backup directory
LOG_FILE="$BACKUP_DIR/backup_log.txt"
echo "Backup started at $(date)" >> "$LOG_FILE"

# Function to perform the backup
function perform_backup() {
    local src_dir=$1
    local dest_dir=$2
    local log_file=$3
    local update=$4

    if $update; then
        rsync -av --update "$src_dir"/* "$dest_dir" | tee -a "$log_file"
    else
        cp -r "$src_dir"/* "$dest_dir"
        echo "Backup of $src_dir to $dest_dir completed at $(date)" >> "$log_file"
    fi
}

# Perform the backup
perform_backup "$SOURCE_DIR" "$BACKUP_DIR" "$LOG_FILE" $UPDATE

# Rename the backup directory if using timestamp and update
if [ $TIMESTAMP ] && [ $UPDATE ]; then
    NEW_BACKUP_DIR="${BACKUP_DIR%_*}_$TIMESTAMP"
    mv "$BACKUP_DIR" "$NEW_BACKUP_DIR"
    BACKUP_DIR=$NEW_BACKUP_DIR
    echo "Backup updated and renamed to $BACKUP_DIR" | tee -a "$BACKUP_DIR/backup_log.txt"
fi

# Copy the files and log the operation
echo "Backup completed successfully."
