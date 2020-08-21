



``` sh
$ rancher project list-members

BINDING-ID                      USER            ROLE            CREATED
p-xxxx:creator-project-owner   Default Admin   project-owner   21 Aug 2020 14:57:01 UTC
```

## Example Output

Example output from the script

```
PROJECT, BINDING-ID, USER, ROLE
risky-project, p-xxxx:creator-project-owner, Default Admin, project-owner
risky-project, p-xxxx:prtb-blcns, Dummy User 2, project-owner
risky-project, p-xxxx:prtb-rddnj, Dummy User 1, project-owner
Default, p-kwkx4:creator-project-owner, Default Admin, project-owner
readonly-project, p-xxxx:creator-project-owner, Default Admin, project-owner
readonly-project, p-xxxx:prtb-756kc, Dummy User 1, read-only
readonly-project, p-xxxx:prtb-dnsq7, Dummy User 2, read-only
System, p-pjnpl:creator-project-owner, Default Admin, project-owner
accessible-project, p-xxxx:creator-project-owner, Default Admin, project-owner
accessible-project, p-xxxx:prtb-4z8sj, Dummy User 2, project-member
accessible-project, p-xxxx:prtb-cj9hw, Dummy User 1, project-member
invisible-project, p-xxxx:creator-project-owner, Default Admin, project-owner
```