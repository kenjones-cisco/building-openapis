## Generate API Server (Golang)

### Summary

This tutorial will explain how to generate an API server in golang using an API definition.

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


### Generate Server

Update the GOPATH environment variable within the container by appending the base directory; e.g. `/tracker`.
Mount the project root directory to base directory `/tracker/src/<import path>` where the `<import path>`
is how you import a golang package.


```bash
docker run --rm \
    -e GOPATH='/go:/tracker' \
    -v ${PWD}:/tracker/src/github.com/myorg/tracker \
    -w /tracker/src/github.com/myorg/tracker \
    quay.io/goswagger/swagger generate server \
        -A TrackerApi \
        -f task-tracker-api.yaml
```


Output:
```
2017/10/06 02:05:24 building a plan for generation
2017/10/06 02:05:24 planning definitions
2017/10/06 02:05:24 planning operations
2017/10/06 02:05:24 grouping operations into packages
2017/10/06 02:05:24 planning meta data and facades
2017/10/06 02:05:24 rendering 3 models
2017/10/06 02:05:24 rendering 1 templates for model Task
2017/10/06 02:05:24 name field Task
2017/10/06 02:05:24 package field models
2017/10/06 02:05:24 creating "task.go" in "models" as definition
2017/10/06 02:05:24 rendering 1 templates for model User
2017/10/06 02:05:24 name field User
2017/10/06 02:05:24 package field models
2017/10/06 02:05:24 creating "user.go" in "models" as definition
2017/10/06 02:05:24 rendering 1 templates for model listTasksOKBody
2017/10/06 02:05:24 name field listTasksOKBody
2017/10/06 02:05:24 package field models
2017/10/06 02:05:24 creating "list_tasks_o_k_body.go" in "models" as definition
2017/10/06 02:05:24 rendering 1 operation groups (tags)
2017/10/06 02:05:24 rendering 4 operations for operations
2017/10/06 02:05:24 rendering 4 templates for operation TrackerApi
2017/10/06 02:05:24 name field createTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "create_task_parameters.go" in "restapi/operations" as parameters
2017/10/06 02:05:24 name field createTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "create_task_urlbuilder.go" in "restapi/operations" as urlbuilder
2017/10/06 02:05:24 name field createTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "create_task_responses.go" in "restapi/operations" as responses
2017/10/06 02:05:24 name field createTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "create_task.go" in "restapi/operations" as handler
2017/10/06 02:05:24 rendering 4 templates for operation TrackerApi
2017/10/06 02:05:24 name field listTasks
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "list_tasks_parameters.go" in "restapi/operations" as parameters
2017/10/06 02:05:24 name field listTasks
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "list_tasks_urlbuilder.go" in "restapi/operations" as urlbuilder
2017/10/06 02:05:24 name field listTasks
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "list_tasks_responses.go" in "restapi/operations" as responses
2017/10/06 02:05:24 name field listTasks
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "list_tasks.go" in "restapi/operations" as handler
2017/10/06 02:05:24 rendering 4 templates for operation TrackerApi
2017/10/06 02:05:24 name field updateTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "update_task_parameters.go" in "restapi/operations" as parameters
2017/10/06 02:05:24 name field updateTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "update_task_urlbuilder.go" in "restapi/operations" as urlbuilder
2017/10/06 02:05:24 name field updateTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "update_task_responses.go" in "restapi/operations" as responses
2017/10/06 02:05:24 name field updateTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "update_task.go" in "restapi/operations" as handler
2017/10/06 02:05:24 rendering 4 templates for operation TrackerApi
2017/10/06 02:05:24 name field viewTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "view_task_parameters.go" in "restapi/operations" as parameters
2017/10/06 02:05:24 name field viewTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "view_task_urlbuilder.go" in "restapi/operations" as urlbuilder
2017/10/06 02:05:24 name field viewTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "view_task_responses.go" in "restapi/operations" as responses
2017/10/06 02:05:24 name field viewTask
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "view_task.go" in "restapi/operations" as handler
2017/10/06 02:05:24 rendering support
2017/10/06 02:05:24 rendering 6 templates for application Tracker
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "configure_tracker.go" in "restapi" as configure
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "main.go" in "cmd/tracker-server" as main
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "embedded_spec.go" in "restapi" as embedded_spec
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "server.go" in "restapi" as server
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "tracker_api.go" in "restapi/operations" as builder
2017/10/06 02:05:24 name field Tracker
2017/10/06 02:05:24 package field operations
2017/10/06 02:05:24 creating "doc.go" in "restapi" as doc
Generation completed!

For this generation to compile you need to have some packages in your GOPATH:

  * github.com/go-openapi/runtime
  * github.com/tylerb/graceful
  * github.com/jessevdk/go-flags

You can get these now with: go get -u -f ./...
```


Files:
```
./cmd
./cmd/tracker-server
./cmd/tracker-server/main.go
./models
./models/list_tasks_o_k_body.go
./models/task.go
./models/user.go
./restapi
./restapi/configure_tracker.go
./restapi/doc.go
./restapi/embedded_spec.go
./restapi/operations
./restapi/operations/create_task.go
./restapi/operations/create_task_parameters.go
./restapi/operations/create_task_responses.go
./restapi/operations/create_task_urlbuilder.go
./restapi/operations/list_tasks.go
./restapi/operations/list_tasks_parameters.go
./restapi/operations/list_tasks_responses.go
./restapi/operations/list_tasks_urlbuilder.go
./restapi/operations/tracker_api.go
./restapi/operations/update_task.go
./restapi/operations/update_task_parameters.go
./restapi/operations/update_task_responses.go
./restapi/operations/update_task_urlbuilder.go
./restapi/operations/view_task.go
./restapi/operations/view_task_parameters.go
./restapi/operations/view_task_responses.go
./restapi/operations/view_task_urlbuilder.go
./restapi/server.go
./task-tracker-api.yaml
```


### Build Server

Create a simple `Dockerfile` to use for running the server. There are multiple different approaches
for compiling the server within a docker image. This is the simplest but there are more efficient
approaches. Checkout [Docker + Golang = &#60;3](https://blog.docker.com/2016/09/docker-golang/) :fa-external-link:


Filename: `Dockerfile`

```Dockerfile
FROM golang:1.9

ENV SRC_DIR=/go/src/github.com/myorg/tracker/

WORKDIR $SRC_DIR
COPY . $SRC_DIR

RUN go get github.com/myorg/tracker/cmd/tracker-server...

CMD ["/go/bin/tracker-server", "--port=8080", "--host=0.0.0.0"]
EXPOSE 8080
```

```bash
docker build --tag tracker-golocal .
```


### Run Server

```bash
docker run -d --rm -p 8080:8080 tracker-golocal
```


#### Example Requests and Responses

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.1 501 Not Implemented
Content-Type: application/json
Date: Tue, 10 Oct 2017 18:06:23 GMT
Content-Length: 52

"operation .ListTasks has not yet been implemented"
```

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 501 Not Implemented
Content-Type: application/json
Date: Tue, 10 Oct 2017 18:06:36 GMT
Content-Length: 51

"operation .ViewTask has not yet been implemented"
```

**Request**

```bash
curl -D - -s -X PUT localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json
Date: Tue, 10 Oct 2017 18:08:18 GMT
Content-Length: 49

{"code":602,"message":"body in body is required"}
```
