## Environment Setup

### Summary

This tutorial will explain how to setup your local environment to be able to generate API Server
stubs, API clients, and API documentation.


!!! info
    Prerequisite [**Docker Installation**](https://docs.docker.com/installation/)


### Install codegen-cli

To install the codegen-cli perform a docker pull.

```bash
docker pull swaggerapi/swagger-codegen-cli
```


If you plan to generate a Server or Client in Golang, you will want to download [go-swagger](https://goswagger.io/) as well.

```bash
docker pull quay.io/goswagger/swagger
```


### Install Documentation Tool(s)

Converting API definition to:

- AsciiDoc
- GitHub Flavored Markdown
- Atlassian Confluence Wiki

```bash
docker pull swagger2markup/swagger2markup
```

Additional conversion from AsciiDoc to:

- HTML5
- PDF
- EPUB

```bash
docker pull asciidoctor/docker-asciidoctor
```


### Copy Example API Definition

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

schemes:
  - http

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

