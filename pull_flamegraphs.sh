#!/bin/bash

# Initialize counters and flags
new_files_count=0
existing_files_count=0
REMOVE=false
FILES_TO_REMOVE=()

# Parse options
while (( "$#" )); do
  case "$1" in
    -r|--rm)
      REMOVE=true
      shift
      ;;
    *) # If an unknown option is provided
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Function to check, pull, and possibly remove files
pull_if_new() {
    local file="/root/$1"
    # Add every file to the removal list if --rm is set
    $REMOVE && FILES_TO_REMOVE+=("$file")

    if [[ ! -f "./$1" ]]; then
        lxc file pull nanolab22$file ./
        echo "Pulled $1"
        ((new_files_count++))
    else
        ((existing_files_count++))
    fi
}

# Fetch files and check if they need to be pulled
while read -r line; do 
    pull_if_new "$line"
done < <(lxc exec nanolab22 -- ls /root | grep flame)

# Remove files if --rm flag was used
if $REMOVE; then
    for file in "${FILES_TO_REMOVE[@]}"; do
        lxc exec nanolab22 -- rm "$file"
    done
fi

# Summary
echo "$new_files_count new files pulled."
echo "$existing_files_count files already existed on host."
