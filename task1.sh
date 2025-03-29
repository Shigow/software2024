#!/bin/bash
#Shauna McGann


# Checking the users input
echo "Reading input..."
if [ -z "$1" ]; then # checks argument $1
    echo "Error: Folder path is required." 
    exit 1 # exists with the error status of 1 if no folder path is given
fi

# Defining paths
target_dir="$1" # folder path given by user
backup_dir="$HOME/backup" #creats backup in the users home
mv_folder="$target_dir/renamed_images" # defined where renamed images will be stored

mkdir -p "$backup_dir" "$mv_folder" # creates backup and mv_folder if they don't exist
# -p ensures no error is thrown if the directory exists

# Finding and renaming the first 10 .jpg files
counter=1 
renamed_files=()

for file in "$target_dir"/*.jpg; do # for loop to loops through each jpg image in the folder
    [ -e "$file" ] || continue  # skip if no .jpg files are found

    if [ $counter -gt 10 ]; then #
        break
    fi

    new_name="sun-foto-$counter.jpg" # creates a new name for the renamed images, 1-10
    mv "$file" "$mv_folder/$new_name" # moves images to the new folder with the new names
    renamed_files+=("$new_name") # adds the new file name to the renamed_files array
    counter=$((counter + 1)) # counter is incremented 
done

# Display renamed file details
echo "Displaying renamed file details:"
for file in "${renamed_files[@]}"; do # for loop, loops through all the renamed files
    full_path="$mv_folder/$file" # stores full path of the renamed files

    if [ -f "$full_path" ]; then # verifies the file exists, -f is a regular file
        owner=$(ls -l "$full_path" | awk '{print $3}') # third column is printed
        size=$(ls -l "$full_path" | awk '{print $5}') # fifth column is printed
        echo "File: $file"
        echo "Owner: $owner"
        echo "Size: $size bytes"
        echo "---------"
    else
        echo "File $file not found." # if file is not found then theres an error.
    fi
done

# Create a backup
tar -czf "$backup_dir/renamed_images.tar.gz" -C "$mv_folder" . # c archive, z compress gzip, f filename. -C archives all files in folder
echo "Your backup has been created in $backup_dir"

# Display home directory contents
ls "$HOME" # lists all the files and directories in the user's home folder, HOME is a given environmental variable.

