#!/bin/bash

# Create CSV file
CSV_FILE_NAME="project-users.csv"
echo "CLUSTER, PROJECT, BINDING-ID, USER, ROLE" > $CSV_FILE_NAME
RANCHER_URL=$(echo "$1")
ACCESS_TOKEN=$(echo "$2")

# query rancher for projects
curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projects" | jq -r '.data[] | [.id,.name,.clusterId] | @csv' | tr -d '"' | while read -r project
do
    PROJECT_ID=$(echo "${project}" | awk -v FS="," '{print $1}')
    PROJECT_NAME=$(echo "${project}" | awk -v FS="," '{print $2}')
    CLUSTER_ID=$(echo "${project}" | awk -v FS="," '{print $3}')
    echo "Examining project $PROJECT_NAME on Cluster:$CLUSTER_ID"

    CLUSTER_NAME=$(curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/clusters/$CLUSTER_ID" | jq -r '.name')

    # query rancher for members of a project
    curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/projectroletemplatebindings?projectId=$PROJECT_ID" | jq -r ".data[] | [.userId, .roleTemplateId] | @csv" | tr -d '"' | while read -r member
    do 
        PROJECT_MEMBER_ID=$(echo "${member}" | awk -F "," '{print $1}')
        PROJECT_ROLE=$(echo "${member}" | awk -F "," '{print $2}')
        
        PROJECT_USER=$(curl -skH "Authorization: Bearer $ACCESS_TOKEN" "$RANCHER_URL/users/$PROJECT_MEMBER_ID" | jq -r ".username")
        if [ -z "$PROJECT_USER" ]; then 
            PROJECT_USER='(unknown)'
        fi        

        echo "$CLUSTER_NAME, $PROJECT_NAME, $PROJECT_MEMBER_ID, $PROJECT_USER, $PROJECT_ROLE" >> $CSV_FILE_NAME

        sleep .5
    done 
done

cat $CSV_FILE_NAME