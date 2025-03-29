#!/bin/bash
#Shauna McGann

USER_FILE="users.txt" #variable to store the user file

# Ensure the script runs as root
if [ "$EUID" -ne 0 ]; then # $EUID stores the effective user id of the current user, EUID 0 is root user.
    echo "You must be root." 
    exit 1 # exits with status code 1, enforcing this error must be resolved before the script is ran
fi

# Make sure users.txt exists
touch "$USER_FILE" #touch command used to create the file or update last modifed timestamp

# Creating users function
create() {
    user="$1" # I used $1  to store the username, then its stored in the user variable

    # checks if the user already exists in the system
    if grep -q "^&user:" /etc/passwd; then # uses grep -q to search for a line that starts with the user in /etc/passwd.
        echo "User $user already exists." 
        return 
    fi
    
    #creates a new user with a home directory
    useradd -m "$user" && echo "$user" >> "$USER_FILE" # && ensures that if the user is created then it is added to the user file
    echo "User $user created."
}

# Function to delete all users in users.txt from the system
delete() {
    while read -r user; do # loop is started to read each line in users.txt and stores it in user to be deleted
        if [ -n "$user" ] && grep -q "$user" /etc/passwd; then 
            userdel -r "$user" # dletes the user and their home directory
            echo "Deleted $user."
        fi
    done < "$USER_FILE" # reads from users.txt until all users are processed

    > "$USER_FILE" # clears the users.txt file by redirecting an empty output.
}

# Here I ensure a username is provided
if [ $# -ne 1 ]; then # $# represents the number of arguments passed to the script, if it is not equal to one theres no argument
    echo "Usage: $0 <username>" # Prints a usage message to show the user how to run the script. $0 is the scripts filename
    exit 1
fi

create "$1" # user is passed to the create function

echo "Users in $USER_FILE:"
cat "$USER_FILE"
echo "User home direcotries"
ls /home/
echo "Showing the /etc/passwd file:"
cat /etc/passwd

# Ask if the user wants to delete accounts
echo -n "Delete created accounts? (yes/no): "
read response

if [ "$response" = "yes" ]; then
    delete
    echo "Users deleted."
else
    echo "Users were not deleted :D."
fi
