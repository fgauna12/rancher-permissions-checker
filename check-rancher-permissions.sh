#!/bin/bash

# Create CSV file
CSV_FILE_NAME="project-users.csv"
echo "PROJECT, BINDING-ID, USER, ROLE" > $CSV_FILE_NAME
RANCHER_URL=$(echo "$1")
ACCESS_TOKEN=$(echo "$2")

declare -A USERS

while read -r user
do
    # create a hash table of user ids and user names
    USER_ID=$(echo "${user}" | awk -F "," '{print $1}')
    USER_NAME=$(echo "${user}" | awk -F "," '{print $2}')
    USERS[$USER_ID]=$(echo "${USER_NAME}")
done <<<$(curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/users" | jq -r '.data[]| [.id,.name] | @csv' | tr -d '"')

# query rancher for projects
curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projects" | jq -r '.data[] | [.id,.name] | @csv' | tr -d '"' | while read -r project
do
    PROJECT_ID=$(echo "${project}" | awk -v FS="," '{print $1}')
    PROJECT_NAME=$(echo "${project}" | awk -v FS="," '{print $2}')
    echo "Examining project $PROJECT_NAME"

    # query rancher for members of a project
    # no way to format output from CLI :-(
    curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projectroletemplatebindings?projectId=$PROJECT_ID" | jq -r ".data[] | [.userId, .roleTemplateId] | @csv" | tr -d '"' | while read -r member
    do 
        PROJECT_MEMBER_ID=$(echo "${member}" | awk -F "," '{print $1}')
        PROJECT_ROLE=$(echo "${member}" | awk -F "," '{print $2}')
        PROJECT_USER=$(echo "${USERS[$PROJECT_MEMBER_ID]}")
        if [ -z "$PROJECT_USER" ]; then 
            PROJECT_USER='(unknown)'
        fi        

        echo "$PROJECT_NAME, $PROJECT_MEMBER_ID, $PROJECT_USER, $PROJECT_ROLE" >> $CSV_FILE_NAME
    done 
done

cat $CSV_FILE_NAME