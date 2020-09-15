``` sh
$ chmod +x ./check-rancher-permissions.sh
$ source ./check-rancher-permissions.sh "[rancher url]" "[api key]"
```
:warning: **No trailing slash** on the rancher url.

## Example Output

Example output from the script

```
CLUSTER, PROJECT, BINDING-ID, USER, ROLE
aks-realworld-staging, aks-project, user-bleh, admin, project-owner
aks-realworld-staging, System, user-bleh, admin, project-owner
aks-realworld-staging, Default, user-bleh, admin, project-owner
local, project 2, user-bleh, admin, project-owner
local, project 1, user-bleh, admin, project-owner
local, System, user-bleh, admin, project-owner
local, Default, user-bleh, admin, project-owner
local, riksy project 1, user-bleh, admin, project-owner
local, riksy project 1, u-p4xt5, dummyuser1, project-owner
```


