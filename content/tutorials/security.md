## Enabling API Security

### Summary

This tutorial will explain how to add security to an API.

!!! info
    Prerequisite [**Environment Setup**](setup.md)


!!! tip
    - `${PWD}` works on Linux, MacOS, and Windows (via Powershell)
    - `%cd%` works on Windows (via cmd)
    - `$(cygpath -m -a "$(pwd)")` works on Windows (via Cygwin)


### Modify API Definition

Add the following details to your API definition.

```yaml
# enable SSL (encrypted connections) vis HTTPS
schemes:
  - https
  - http

# add OAuth2 security
securityDefinitions:
  token:
    type: oauth2
    tokenUrl: https://cloudsso.cisco.com/as/token.oauth2
    flow: password
    scopes:
      write:tasks: create and modify tasks
      read:task: read tasks

# enable security for all read APIs

# within the body of each GET operation
          security:
            - token:
                - read:tasks

# within the body of each POST/PUT/PATCH/DELETE operation
          security:
            - token:
                - write:tasks
```


Filename: `task-tracker-api.yaml`

```yaml
# Original source
# https://raw.githubusercontent.com/go-swagger/go-swagger/master/examples/task-tracker/swagger.yml
swagger: "2.0"
info:
    title: Issue Tracker
    description: |
        This application implements a very simple issue tracker.
    version: "1.0.0"

# enable SSL (encrypted connections) vis HTTPS
schemes:
  - https
  - http

# add OAuth2 security
securityDefinitions:
  token:
    type: oauth2
    tokenUrl: https://cloudsso.cisco.com/as/token.oauth2
    flow: password
    scopes:
      write:tasks: create and modify tasks
      read:tasks: read tasks

produces:
  - application/json
consumes:
  - application/json

# API versioning (Major Version)
basePath: /v1

definitions:
    Task:
        title: Task
        description: >
          Task is the main entity in this application. Everything revolves around
          tasks and managing them.
        type: object
        properties:
          id:
            title: The id of the task.
            description: >-
              A unique identifier for the task. These are created in ascending order.
            type: string
            format: uuid
          title:
            title: The title of the task.
            description: |
              The title for a task.
            type: string
          description:
            title: The description of the task.
            description: >
              The task description is a longer, more detailed description of the issue.
            type: string
          severity:
            type: integer
            format: int32
          effort:
            description: the level of effort required to get this task completed
            type: integer
            format: int32
          status:
            title: the status of the issue
            description: |
              the status of the issue
            type: string
          assignedTo:
            $ref: '#/definitions/User'
          reportedBy:
            $ref: '#/definitions/User'

    User:
        title: User
        description: >
          This representation of a user is mainly meant for inclusion in other
          models, or for list views.
        type: object
        properties:
          id:
            title: A unique identifier for a user.
            description: >
              This id is automatically generated on the server when a user is created.
            type: string
            format: uuid
          screenName:
            title: The screen name for the user.
            description: |
              This is used for vanity type urls as well as login credentials.
            type: string

paths:
    /tasks:
        get:
          operationId: listTasks
          summary: Lists the tasks
          description: |
            List tasks.
          security:
            - token:
                - read:tasks
          responses:
            200:
              description: Successful response
              schema:
                title: TaskList
                type: array
                items:
                  $ref: '#/definitions/Task'
        post:
          operationId: createTask
          summary: Creates a 'Task' object.
          description: |
            Allows for creating a task.
          security:
            - token:
                - write:tasks
          parameters:
            - name: body
              in: body
              description: The task to create
              required: true
              schema:
                $ref: '#/definitions/Task'
          responses:
            201:
              description: Task created

    /tasks/{id}:
        parameters:
          - name: id
            description: The id of the task
            in: path
            required: true
            type: string
            format: uuid
        get:
          operationId: viewTask
          summary: Gets the details for a task.
          description: |
            The details view of a task.
          security:
            - token:
                - read:tasks
          responses:
            200:
              description: Task details
              schema:
                $ref: '#/definitions/Task'
        put:
          operationId: updateTask
          summary: Updates the details for a task.
          description: |
            Allows for updating a task.
          security:
            - token:
                - write:tasks
          parameters:
            - name: body
              in: body
              description: The task to update
              required: true
              schema:
                $ref: '#/definitions/Task'
          responses:
            200:
              description: Task details
              schema:
                $ref: '#/definitions/Task'
```


### Java Implementation

#### Validate API Definition

```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli validate \
    -i task-tracker-api.yaml
```


#### Generate Server

Filename: `codegen_config.json`

```json
{
  "artifactId": "tracker",
  "groupId": "com.cisco.tracker",
  "basePackage": "com.cisco.tracker",
  "apiPackage": "com.cisco.tracker.api",
  "configPackage": "com.cisco.tracker.config",
  "modelPackage": "com.cisco.tracker.model",
  "hideGenerationTimestamp": true,
  "dateLibrary": "java8",
  "useBeanValidation": true,
  "licenseUrl": ""
}
```


```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli generate \
    -i task-tracker-api.yaml \
    --lang spring \
    -c codegen_config.json
```

The Output and Files will be the same as previously generated except that within the file `TasksApi.java`
there will now be additional annotation indicating that Authorization is now required.

```java
    @ApiOperation(value = "Creates a 'Task' object.", notes = "Allows for creating a task. ", response = Void.class, authorizations = {
        @Authorization(value = "token", scopes = {
            @AuthorizationScope(scope = "write:tasks", description = "create and modify tasks")
            })
    }, tags={  })
    @ApiResponses(value = {
        @ApiResponse(code = 201, message = "Task created") })
    @RequestMapping(value = "/tasks",
        produces = { "application/json" },
        consumes = { "application/json" },
        method = RequestMethod.POST)

    @ApiOperation(value = "Lists the tasks", notes = "List tasks. ", response = Task.class, responseContainer = "List", authorizations = {
        @Authorization(value = "token", scopes = {
            @AuthorizationScope(scope = "read:tasks", description = "read tasks")
            })
    }, tags={  })
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "Successful response", response = Task.class, responseContainer = "List") })
    @RequestMapping(value = "/tasks",
        produces = { "application/json" },
        consumes = { "application/json" },
        method = RequestMethod.GET)
```


#### Generate Client

Filename: `codegen_config.json`

```json
{
  "artifactId": "tracker",
  "groupId": "com.cisco.tracker",
  "basePackage": "com.cisco.tracker",
  "apiPackage": "com.cisco.tracker.api",
  "configPackage": "com.cisco.tracker.config",
  "modelPackage": "com.cisco.tracker.model",
  "hideGenerationTimestamp": true,
  "dateLibrary": "java8",
  "useBeanValidation": true,
  "licenseUrl": ""
}
```


```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli generate \
    -i task-tracker-api.yaml \
    --lang java \
    -c codegen_config.json
```

The Output and Files will be the same as previously generated except that within the file `ApiClient.java`
there will now be configuration for the authentications.

```java
    public ApiClient() {
        httpClient = new OkHttpClient();


        verifyingSsl = true;

        json = new JSON();

        // Set default User-Agent.
        setUserAgent("Swagger-Codegen/1.0.0/java");

        // Setup authentications (key: authentication name, value: authentication).
        authentications = new HashMap<String, Authentication>();
        authentications.put("token", new OAuth());
        // Prevent the authentications from being modified.
        authentications = Collections.unmodifiableMap(authentications);
    }
```


### Golang Implementation

Update the GOPATH environment variable within the container by appending the base directory; e.g. `/tracker`.
Mount the project root directory to base directory `/tracker/src/<import path>` where the `<import path>`
is how you import a golang package.


#### Validate API Definition

```bash
docker run --rm -v ${PWD}:/local -w /local quay.io/goswagger/swagger validate task-tracker-api.yaml
```


#### Generate Server

```bash
docker run --rm \
    -e GOPATH='/go:/tracker' \
    -v ${PWD}:/tracker/src/gitscm.cisco.com/myorg/go-trackerclient \
    -w /tracker/src/gitscm.cisco.com/myorg/go-trackerclient \
    quay.io/goswagger/swagger generate server \
        -A TrackerApi \
        -f task-tracker-api.yaml \
        --principal models.User
```

The Output and Files will be the same as previously generated except that within the file `configure_tracker.go`
there will now be additional configuration indicating that token authenication is now required.

```go
  api.TokenAuth = func(token string, scopes []string) (*models.User, error) {
    return nil, errors.NotImplemented("oauth2 bearer auth (token) has not yet been implemented")
  }
```


#### Generate Client

```bash
docker run --rm \
    -e GOPATH='/go:/tracker' \
    -v ${PWD}:/tracker/src/gitscm.cisco.com/myorg/go-trackerclient \
    -w /tracker/src/gitscm.cisco.com/myorg/go-trackerclient \
    quay.io/goswagger/swagger generate client \
        -A TrackerApi \
        -f task-tracker-api.yaml \
        --principal models.User
```

The Output and Files will be the same as previously generated except that within the file `operations_client.go`
there will now be additional parameter for each operation indicating that token authenication is now required.

```go
func (a *Client) CreateTask(params *CreateTaskParams, authInfo runtime.ClientAuthInfoWriter) (*CreateTaskCreated, error)
```


### Additional information

If the security configuration for each operation is identical, then the `security` can be defined globally within
the API definition.

```yaml
# Adds security for all API operations
security:
  - token: []
```

If an operation does not require security, then `security` must be defined for each individual operation
and the operation(s) that should be unprotected (requires no authentication) should not have `security`
defined within the operation.

```yaml
paths:
    /tasks:
        get:
          operationId: listTasks
          summary: Lists the tasks
          description: |
            List tasks.
          responses:
            200:
              description: Successful response
              schema:
                title: TaskList
                type: array
                items:
                  $ref: '#/definitions/Task'
```
