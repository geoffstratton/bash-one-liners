#!/bin/bash

### Get input from a user and creates an account on the local system.
read -p 'Enter the username: ' USER_NAME
read -p 'Enter their real name: ' REAL_NAME
read -p 'Enter their password: ' PASSWORD

# Create the user.
adduser ${USER_NAME} --gecos "${REAL_NAME}" --disabled-password
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# Force the user to change their password when they log in.
passwd --expire ${USER_NAME}

### Generates a random password for each user specified on the command line.
for USER_NAME in "${@}"
do
  PASSWORD=$(date +s%N | sha256sum | head -c48)
  echo "${USER_NAME}: ${PASSWORD}"
done

### Show the open network ports on a system.
netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

### Display the three most visited URLs for a given web server logfile.
LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open ${LOG_FILE}."
  exit 1
fi

cut -d '"' -f 2 access_log |  cut -d ' ' -f 2 | sort | uniq -c | sort -n | tail -3

### Basic case statement.
case "${1}" in
  start)
    echo 'Starting.'
    ;;
  stop)
    echo 'Stopping.'
    ;;
  status|state)
    echo 'Status:'
    ;;
  *)
    echo 'Supply a valid option.'
    exit 1
    ;;
esac

#########################
#### Some grep stuff ####
#########################

# Find all examples of 'string' in the current directory and subdirectories:
grep -r 'string' *

# find all .py files, then scan them for 'string' and output the findings to disk: 
find . -name '*.py' -exec grep 'string' {} \; > found.txt

# cat a file, search for 'string', add the line numbers where 'string' is found, and output to disk: 
cat file.txt | grep -n 'string' > found.txt

# Use the results of the whoami shell command to search file.py, then output results to disk:  
grep `whoami` file.py > found.txt

# Use the value of the $HOME environment variable to search file.py, then output the results to disk:
grep "$HOME" file.py > found.txt

# Monitor the system log, looking for 'ERROR' in the last 10 lines:
tail -f /var/log/messages | grep ERROR

# Show IP addresses from a file:
grep -E '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b' maillog

# Show email addresses:
grep -Ei '\b[a-z0-9]{1,}@*\.(com|net|org|uk|mil|gov|edu)\b' maillog

# Show Social Security numbers:
grep -E '\b[0-9]{3}( |-|)[0-9]{2}( |-|)[0-9]{4}\b' employees.csv

# Given the file classes.txt, find lines containing two or more occurrences of "History":
History is best learned in Algebra.
History is best learned in English.
History is best learned in History. 
History is best learned in Calculus.

grep -Ein '(history).*\1' classes.txt
# Output: 
3:History is best learned in History.

# Match strings across multiple lines (using Perl-style grep for the newline (\n) character):
grep -P '(?m)phone\nnumber' employees.csv

#############################
#### Some sed one-liners ####
#############################

# Find "text" at any point/beginning/end of a line:
sed 's/text OR ^text OR text$//' file.txt

# Replace all instances of "text", case-insensitive first letter, with "blar" in file.txt:
sed 's/[Tt]ext/blar/g' file.txt

# Delete all lines that do or don't contain "blar":
sed '/blar/d' file.txt
sed '/blar/!d' file.txt

# Replace all instances of "text" with "blar" from line 1-100, or from line 101 to EOF:
sed '1,100 s/text/blar/g' file.txt
sed '101,$ s/text/blar/g' file.txt

# Change "text" to "blar" on all lines except between START and END:
sed '/START/,/END/!s/text/blar/g' file.txt

# Redo all lines in file.txt but add parentheses:
sed 's/.*/( & )/' file.txt

# Delete blank lines in file.txt:
sed '/^$/d' file.txt

# Lowercase or uppercase an entire file:
sed 's/.*/\L&/' file.txt
sed 's/.*/\U&/' file.txt

# Uppercase first letter of each word on current line:
sed 's/\<./\u&/g' file.txt

#############################
#### Some awk one-liners ####
#############################

# Print the fifth field from /etc/passwd, delimited by ':', from any line containing 'admin':
awk -F: '/admin/ { print $5, "Records: "NR, "Fields: "NF }' /etc/passwd

# Double-space or triple-space a file.
awk '1;{print ""}' file.txt  # This is the same as $ awk '{print $0 "\n"}' file.txt
awk '1;{print "\n"}' file.txt

# Number each line with its line number, followed by tab:
awk '{print NR "\t" $0}' file.txt

# Count the lines in a file:
awk 'END{print NR}' file.txt

# Print every line with more than 4 fields, or every line where the value of the last field is > 4:
awk 'NF > 4' file.txt
awk '$NF > 4' file.txt

# Delete leading whitespace (align text left), delete trailing whitespace:
awk '{sub(/^[ \t]+/, "")};1' file.txt
awk '{sub(/[ \t]+$/, "")};1' file.txt

# Match/inverted match of a field against a regular expression:
awk '$1  ~ /^[a-f]/' file.txt # print if match
awk '$1 !~ /^[a-f]/' file.txt # print if doesn't match

# Delete all blanks lines from a file:
awk NF file.txt # this works because 'NF' = 0 for a blank record, thus nothing is printed
