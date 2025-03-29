#!/bin/bash
#Shauna McGann

# function for grub.txt file
grub(){
   if [[ ! -f grub.txt ]]; then 
       echo "grub.txt not found"
       return
   fi
   
   echo "Occurences of 'Linux' in grub.txt:"
   grep -o "Linux" grub.txt | wc -l # finds and prints only the word linux for each occurrence. wc -l (count lines/occurences)
   
   echo "The lines containing 'Linux' are:"
   grep "Linux" grub.txt # displays the lines containing linux
   
   echo "Number of empty lines:"
   grep -c "^$" grub.txt #  -c count matches, ^$ empty lines 
   
   echo "Putting the comment lines into new file."
   grep "^#" grub.txt > comments.txt 
   cat comments.txt 
   #showing the files new contents with the commented lines from grub
}

ufw(){
   if [[ ! -f ufw.txt ]]; then
       echo "ufw.txt not found."
       return
   fi
   
   echo "The lines that start with '1' and end with 'y':"
   grep -E 'bl[a-zA-Z]*y\b' ufw.txt # finds lines that start with l and end with l,\b ensures whole word
   
   echo "Number of lines that start with 'D':" 
   grep -c "^D" ufw.txt 
   
   echo "Odd numbered lines from the ufw file:"
   linenum=1 #line counter
   while read -r line;
       do
          if (( linenum % 2 == 1 )) # onlys runs for odd numbers
              then
                  echo "$line" 
          fi
          ((linenum++)) #incrementing the line counter
   done < ufw.txt
}

writefile(){
   echo -n "Enter a file name:"
   read filename #reads the users input and uses it as the filename
   touch "$filename" #file is created if it doesnt exist or timestamp is update if it doesn't
   
   echo "Enter text to be added to the file. Type 'end' on a new line to stop."
   while read -r line;
       do
          [[ "$line" == "end" ]] && break
          echo "$line" >> "$filename"
   done
}

# interactive menu that is used to select which action the user wants
while true
   do
       echo "Interactive Menu:"
       echo "1. Quantity"
       echo "2. Details"
       echo "3. Write"
       echo "4. Exit"
       echo "Enter your choice below:"
       read choice # taking the users input and reading it, setting the variable "choice"
       
       case "$choice" in
           1) grub ;;
           2) ufw ;;
           3) writefile ;;
           4) echo "Bye :D"; exit 0 ;;
           *) echo "You can only choose betwen 1 and 4." ;;
       esac
done
