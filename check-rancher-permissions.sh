#!/bin/bash

# Create CSV file
CSV_FILE_NAME="project-users.csv"
echo "PROJECT, BINDING-ID, USER, ROLE" > $CSV_FILE_NAME

# query rancher for projects
rancher project ls | tail -n +2 | while read -r project
do
    PROJECT_ID=$(echo "${project}" | awk '{print $1}')
    PROJECT_NAME=$(echo "${project}" | awk '{print $2}')
    echo "Examining project $PROJECT_NAME"

    # query rancher for members of a project
    # no way to format output from CLI :-(
    rancher project list-members --project-id "${PROJECT_ID}" | tail -n +2 | sed -E 's/(\s\s+)/,/g' | while read -r member
    do 
        PROJECT_MEMBER_ID=$(echo "${member}" | awk -F "," '{print $1}')
        PROJECT_USER=$(echo "${member}" | awk -F "," '{print $2}')
        PROJECT_ROLE=$(echo "${member}" | awk -F "," '{print $3}')

        echo "$PROJECT_NAME, $PROJECT_MEMBER_ID, $PROJECT_USER, $PROJECT_ROLE" >> $CSV_FILE_NAME
    done 
done

cat $CSV_FILE_NAME