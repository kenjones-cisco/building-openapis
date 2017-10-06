## Generate API Client (Golang)

### Summary

This tutorial will explain how to generate an API client in golang using an API definition.

!!! info
    Prerequisite [**Environment Setup**](setup.md)


!!! tip
    - `${PWD}` works on Linux, MacOS, and Windows (via Powershell)
    - `%cd%` works on Windows (via cmd)
    - `$(cygpath -m -a "$(pwd)")` works on Windows (via Cygwin)


### Validate API Definition

```bash
docker run --rm -v ${PWD}:/local -w /local quay.io/goswagger/swagger validate task-tracker-api.yaml
```


### Generate Client

Update the GOPATH environment variable within the container by appending the base directory; e.g. `/tracker`.
Mount the project root directory to base directory `/tracker/src/<import path>` where the `<import path>`
is how you import a golang package.


```bash
docker run --rm \
    -e GOPATH='/go:/tracker' \
    -v ${PWD}:/tracker/src/github.com/myorg/go-trackerclient \
    -w /tracker/src/github.com/myorg/go-trackerclient \
    quay.io/goswagger/swagger generate client \
        -A TrackerApi \
        -f task-tracker-api.yaml
```


Output:
```
2017/10/06 01:55:25 building a plan for generation
2017/10/06 01:55:25 planning definitions
2017/10/06 01:55:25 planning operations
2017/10/06 01:55:25 grouping operations into packages
2017/10/06 01:55:25 planning meta data and facades
2017/10/06 01:55:25 rendering 1 templates for model User
2017/10/06 01:55:25 name field User
2017/10/06 01:55:25 package field models
2017/10/06 01:55:25 creating "user.go" in "models" as definition
2017/10/06 01:55:25 rendering 1 templates for model listTasksOKBody
2017/10/06 01:55:25 name field listTasksOKBody
2017/10/06 01:55:25 package field models
2017/10/06 01:55:25 creating "list_tasks_o_k_body.go" in "models" as definition
2017/10/06 01:55:25 rendering 1 templates for model Task
2017/10/06 01:55:25 name field Task
2017/10/06 01:55:25 package field models
2017/10/06 01:55:25 creating "task.go" in "models" as definition
2017/10/06 01:55:25 rendering 2 templates for operation
2017/10/06 01:55:25 name field createTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "create_task_parameters.go" in "client/operations" as parameters
2017/10/06 01:55:25 name field createTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "create_task_responses.go" in "client/operations" as responses
2017/10/06 01:55:25 rendering 2 templates for operation
2017/10/06 01:55:25 name field listTasks
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "list_tasks_parameters.go" in "client/operations" as parameters
2017/10/06 01:55:25 name field listTasks
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "list_tasks_responses.go" in "client/operations" as responses
2017/10/06 01:55:25 rendering 2 templates for operation
2017/10/06 01:55:25 name field updateTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "update_task_parameters.go" in "client/operations" as parameters
2017/10/06 01:55:25 name field updateTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "update_task_responses.go" in "client/operations" as responses
2017/10/06 01:55:25 rendering 2 templates for operation
2017/10/06 01:55:25 name field viewTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "view_task_parameters.go" in "client/operations" as parameters
2017/10/06 01:55:25 name field viewTask
2017/10/06 01:55:25 package field operations
2017/10/06 01:55:25 creating "view_task_responses.go" in "client/operations" as responses
2017/10/06 01:55:25 rendering 1 templates for operation group
2017/10/06 01:55:25 name field operations
2017/10/06 01:55:25 creating "operations_client.go" in "client/operations" as client
2017/10/06 01:55:25 rendering 1 templates for application Tracker
2017/10/06 01:55:25 name field Tracker
2017/10/06 01:55:25 package field client
2017/10/06 01:55:25 creating "tracker_client.go" in "client" as facade
Generation completed!

For this generation to compile you need to have some packages in your GOPATH:

  * github.com/go-openapi/runtime
  * golang.org/x/net/context
  * golang.org/x/net/context/ctxhttp

You can get these now with: go get -u -f ./...
```


Files:
```
./client
./client/operations
./client/operations/create_task_parameters.go
./client/operations/create_task_responses.go
./client/operations/list_tasks_parameters.go
./client/operations/list_tasks_responses.go
./client/operations/operations_client.go
./client/operations/update_task_parameters.go
./client/operations/update_task_responses.go
./client/operations/view_task_parameters.go
./client/operations/view_task_responses.go
./client/tracker_client.go
./models
./models/list_tasks_o_k_body.go
./models/task.go
./models/user.go
./task-tracker-api.yaml
```

