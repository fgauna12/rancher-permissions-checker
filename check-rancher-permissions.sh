#!/bin/bash

# Create CSV file
CSV_FILE_NAME="project-users.csv"
echo "PROJECT, BINDING-ID, USER, ROLE" > $CSV_FILE_NAME
RANCHER_URL=$(echo "$1")
ACCESS_TOKEN=$(echo "$2")

# query rancher for projects
# rancher project ls | tail -n +2 | while read -r project
curl -sH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projects" | jq -r '.data[] | [.id,.name] | @csv' | tr -d '"' | while read -r project
do
    PROJECT_ID=$(echo "${project}" | awk -v FS="," '{print $1}')
    PROJECT_NAME=$(echo "${project}" | awk -v FS="," '{print $2}')
    echo "Examining project $PROJECT_NAME"

    # query rancher for members of a project
    # no way to format output from CLI :-(
    # rancher project list-members --project-id "${PROJECT_ID}" | tail -n +2 | sed -E 's/(\s\s+)/,/g' | while read -r member
    curl -sH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projectroletemplatebindings?projectId=$PROJECT_ID" | jq -r ".data[] | [.userId, .roleTemplateId] | @csv" | tr -d '"' | while read -r member
    do 
        PROJECT_MEMBER_ID=$(echo "${member}" | awk -F "," '{print $1}')
        PROJECT_ROLE=$(echo "${member}" | awk -F "," '{print $2}')
        PROJECT_USER=$(echo "todo")        

        echo "$PROJECT_NAME, $PROJECT_MEMBER_ID, $PROJECT_USER, $PROJECT_ROLE" >> $CSV_FILE_NAME
    done 
done

cat $CSV_FILE_NAME