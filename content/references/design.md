## Designing an API

Using the recommended [Design First](openapi.md#design-first) approach, establish a clear understanding of the
main API functionality.

Resources are structures that represent data being passed in as part of a request or returned as
part of a response.

Operations are the actions that a resource supports. Start with the basic CRUD actions.


Questions to ask yourself

1. What resource(s) will my API be operating on?
2. What operation(s) will clients be able to perform on the resource(s)?


Resources Example

```
Task
    - id (uuid string): Unique identifier
    - title (string): Title of task
    - description (string): Detailed description of the task
    - status (string): Status of the task
    - severity (int32): Level of important of task
    - effort (int32): Level of effort required to complete task
    - reportedBy (User): The person that identified the task.
    - assignedTo (User): The person assigned to work on the task.

User
    - id (uuid string): Unique identifier
    - screenName (string): Name of user
```


Operations Example

- List Task(s)
- Create Task
- View Task
- Update Task


### Basic Structure

Three major parts of the [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification) that
provide the overall definition of an API.


#### info

The `info` part of the specification represents the API Metadata.

Example
```yaml
swagger: 2.0
info:
    title: Issue Tracker
    description: |
        This application implements a very simple issue tracker.
    version: 1.0.0

schemes:
  - http

produces:
  - application/json
consumes:
  - application/json

# API versioning (Major Version)
basePath: /v1
```


#### definitions

The `definitions` part of the specification represents the API Resource(s).

Example
```yaml
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
```


#### paths

The `paths` part of the specification represents the API Operation(s).

Example
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
        get:
          operationId: viewTask
          summary: Gets the details for a task.
          description: |
            The details view of a task.
          parameters:
            - in: path
              name: id
              description: The id of the task
              type: string
              format: uuid
              required: true
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
