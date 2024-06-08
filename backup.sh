#!/bin/bash

# Function to display the usage of the program
function display_help() {
    echo "Usage: $0 [-s] source_directory [destination_directory]"
    echo ""
    echo "This script copies all files from the specified source directory"
    echo "to the specified destination directory or to a backup folder"
    echo "in the current directory named after the source directory."
    echo ""
    echo "Options:"
    echo " -s       Make the backup directory not hidden"
    echo " -help    Display this help message and exit"
}

# Check for the -help flag
if [ "$1" == "-help" ]; then
    display_help
    exit 0
fi

# Initialize variables
HIDDEN=true
SOURCE_DIR=""
DEST_DIR=""
BASE_DIR=""

# Parse options
while getopts ":s" opt; do
    case ${opt} in
        s )
            HIDDEN=false
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
    echo "Usage: $0 [-s] source directory [destination_directory]"
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

# Create the .backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Copy the files
cp -r "$SOURCE_DIR"/* "$BACKUP_DIR"