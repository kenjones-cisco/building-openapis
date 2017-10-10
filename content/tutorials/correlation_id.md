## Adding Correlation Id

### Summary

This tutorial will explain how to add a Correlation Id to an API.

!!! info
    Prerequisite [**Environment Setup**](setup.md)


!!! tip
    - `${PWD}` works on Linux, MacOS, and Windows (via Powershell)
    - `%cd%` works on Windows (via cmd)
    - `$(cygpath -m -a "$(pwd)")` works on Windows (via Cygwin)


### Modify API Definition

The actual header key to use can vary based on most published resources. The most common header keys are:

- `X-Request-Id`
- `X-Correlation-Id`

Just be consistent within the API definition to avoid confusion by clients and developers.


Add the following details to your API definition.

```yaml
# Define globally and then reference within the parameter(s) of each path item
parameters:
    request_id:
        name: X-Request-Id
        in: header
        description: Unique identifer associated with request
        required: false
        type: string
        format: uuid

# Add to each operation response
          headers:
            X-Request-Id:
              description: Unique identifer associated with request
              type: string
              format: uuid
```

The parameter should **not** be required as the value should only be created by a calling client.
By always returning the value back to a caller with the response, the caller can use that value for
logging or as a way to provide an identifier for a specific request to a support team.


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

# define global parameters for reuse
parameters:
    request_id:
        name: X-Request-Id
        in: header
        description: Unique identifer associated with request
        required: false
        type: string
        format: uuid

paths:
    /tasks:
        # reference the global parameter "request_id"
        parameters:
            - $ref: "#/parameters/request_id"
        get:
          operationId: listTasks
          summary: Lists the tasks
          description: |
            List tasks.
          responses:
            200:
              description: Successful response
              # add "X-Request-Id" to response header
              headers:
                X-Request-Id:
                  description: Unique identifer associated with request
                  type: string
                  format: uuid
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
              # add "X-Request-Id" to response header
              headers:
                X-Request-Id:
                  description: Unique identifer associated with request
                  type: string
                  format: uuid

    /tasks/{id}:
        parameters:
          - name: id
            description: The id of the task
            in: path
            required: true
            type: string
            format: uuid
          # reference the global parameter "request_id"
          - $ref: "#/parameters/request_id"
        get:
          operationId: viewTask
          summary: Gets the details for a task.
          description: |
            The details view of a task.
          responses:
            200:
              description: Task details
              # add "X-Request-Id" to response header
              headers:
                X-Request-Id:
                  description: Unique identifer associated with request
                  type: string
                  format: uuid
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
              # add "X-Request-Id" to response header
              headers:
                X-Request-Id:
                  description: Unique identifer associated with request
                  type: string
                  format: uuid
              schema:
                $ref: '#/definitions/Task'
```


### Java Implementation

- [Validate](server_java.md#validate-api-definition) modified API Definition
- [Generate](server_java.md#generate-server) server using modified API definition

Define a simple request scoped component `Correlation.java`

```java
package com.example.tracker.config;

import java.util.UUID;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

@Component
@Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class Correlation {
  private UUID id;

  public UUID getId() {
    if (id == null) {
      id = UUID.randomUUID();
    }

    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }
}
```


Define a request filter `request/filter/CorrelationFilter.java`

```java
package com.example.tracker.request.filter;

import com.example.tracker.config.Correlation;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component("CorrelationFilter")
public class CorrelationFilter implements Filter {

    public static final String REQUEST_ID_HEADER = "X-Request-Id";

    @Autowired private Correlation correlation;

    /**
     * {@inheritDoc}
     */
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // empty method
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void destroy() {
        // empty method
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        if ( request instanceof HttpServletRequest && response instanceof HttpServletResponse ) {
            doHttpFilter((HttpServletRequest)request, (HttpServletResponse)response, chain);
        } else {
            // otherwise just pass through
            chain.doFilter(request, response);
        }
    }

    /**
     * Performs 'enrichment' of incoming HTTP request and response.
     *
     * @param request the http servlet request
     * @param response the http servlet response
     * @param chain the filter processing chain
     * @throws IOException if any error occurs
     * @throws ServletException if any error occurs
     */
    private void doHttpFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws IOException, ServletException {

        String requestId = getRequestId(request);
        // verifies the correlation id was set
        if ( StringUtils.isBlank(requestId) ) {
            requestId = correlation.getId().toString();
        }

        // populates the attribute
        final ServletRequest req = enrichRequest(request, requestId);
        final ServletResponse resp = enrichResponse(response, requestId);

        // proceeds with execution
        chain.doFilter(req, resp);
    }

    private String getRequestId(HttpServletRequest request) {
        return request.getHeader(REQUEST_ID_HEADER);
    }

    private ServletRequest enrichRequest(HttpServletRequest request, String correlationId) {

        final CorrelatedServletRequest req = new CorrelatedServletRequest(request);
        req.setHeader(REQUEST_ID_HEADER, correlationId);
        return req;
    }

    private ServletResponse enrichResponse(HttpServletResponse response, String correlationId) {

        final HttpServletResponseWrapper resp = new HttpServletResponseWrapper(response);
        resp.setHeader(REQUEST_ID_HEADER, correlationId);
        return resp;
    }

    /**
     * An http servlet wrapper that allows to register additional HTTP headers.
     *
     * @author Jakub Narloch
     */
    private static class CorrelatedServletRequest extends HttpServletRequestWrapper {

        /**
         * Map with additional customizable headers.
         */
        private final Map<String, String> additionalHeaders = new ConcurrentHashMap<>();

        /**
         * Creates a ServletRequest adaptor wrapping the given request object.
         *
         * @param request The request to wrap
         * @throws IllegalArgumentException if the request is null
         */
        public CorrelatedServletRequest(HttpServletRequest request) {
            super(request);
        }

        /**
         * Sets the header value.
         *
         * @param key the header name
         * @param value the header value
         */
        public void setHeader(String key, String value) {

            this.additionalHeaders.put(key, value);
        }

        @Override
        public String getHeader(String name) {
            if ( additionalHeaders.containsKey(name) ) {
                return additionalHeaders.get(name);
            }
            return super.getHeader(name);
        }

        @Override
        public Enumeration<String> getHeaders(String name) {

            final List<String> values = new ArrayList<>();
            if ( additionalHeaders.containsKey(name) ) {
                values.add(additionalHeaders.get(name));
            } else {
                values.addAll(Collections.list(super.getHeaders(name)));
            }
            return Collections.enumeration(values);
        }

        @Override
        public Enumeration<String> getHeaderNames() {

            final Set<String> names = new HashSet<>();
            names.addAll(additionalHeaders.keySet());
            names.addAll(Collections.list(super.getHeaderNames()));
            return Collections.enumeration(names);
        }
    }

}
```

Update `pom.xml` by adding new dependency

```xml
    <dependency>
      <groupId>org.apache.commons</groupId>
      <artifactId>commons-lang3</artifactId>
      <version>3.5</version>
    </dependency>
```


- [Build](server_java.md#build-server) server using modified API definition
- [Run](server_java.md#run-server) server using modified API definition


#### Example Requests and Responses

**Request**

```bash
curl -D - -s -H "Content-type: application/json" localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.1 200
X-Request-Id: 8086179e-1bb4-411a-9052-4a2375cd8406
Content-Length: 0
Date: Tue, 10 Oct 2017 20:26:29 GMT

```

**Request**

```bash
curl -D - -s -H "Content-type: application/json" localhost:8080/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313
```

**Response**

```http
HTTP/1.1 200
X-Request-Id: 2c4a7f65-73b8-458b-aada-9109f58649a4
Content-Length: 0
Date: Tue, 10 Oct 2017 20:28:23 GMT

```

**Request**

```bash
curl -D - -s -X PUT -H "Content-type: application/json" -d '{}' localhost:8080/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313
```

**Response**

```http
HTTP/1.1 200
X-Request-Id: 017ceafc-dcc2-4945-89e3-f43d4de3ead6
Content-Length: 0
Date: Tue, 10 Oct 2017 20:29:03 GMT

```


### Golang Implementation

- [Validate](server_golang.md#validate-api-definition) modified API Definition
- [Generate](server_golang.md#generate-server) server using modified API definition

Define a simple middleware `restapi/requestid.go`

```go
package restapi

import (
    "net/http"

    uuid "github.com/hashicorp/go-uuid"
)

// HeaderKey is the request header the value is set on.
const HeaderKey = "X-Request-Id"

// RequestID is a middleware that generates a unique id and adds to the request header
type RequestID struct {
    next http.Handler
}

// NewRequestIDGenerator creates a new instance of the RequestID Middleware.
func NewRequestIDGenerator(next http.Handler) http.Handler {
    return &RequestID{next}
}

func (m *RequestID) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
    id := getOrCreateID(r.Header.Get(HeaderKey))
    if id != "" {
        r.Header.Set(HeaderKey, id)
        rw.Header().Set(HeaderKey, id)
    }

    m.next.ServeHTTP(rw, r)
}

func getOrCreateID(v string) string {
    if v == "" {
        u, _ := uuid.GenerateUUID()
        return u
    }
    return v
}
```


Add the middleware to the generated file `restapi/configure_tracker.go`.

```go
// The middleware configuration happens before anything, this middleware also applies to serving the swagger.json document.
// So this is a good place to plug in a panic handling middleware, logging and metrics
func setupGlobalMiddleware(handler http.Handler) http.Handler {
    // assumes the middleware is in the same package
    return NewRequestIDGenerator(handler)
}
```

- [Build](server_golang.md#build-server) server using modified API definition
- [Run](server_golang.md#run-server) server using modified API definition


#### Example Requests and Responses

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.1 501 Not Implemented
Content-Type: application/json
X-Request-Id: 03de5a5a-7c77-a9c0-93de-ad4268bbc227
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
X-Request-Id: 199a1124-599e-5731-9100-741721540a4a
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
X-Request-Id: dd9d765f-81c6-c23d-e459-4dfb318aa816
Date: Tue, 10 Oct 2017 18:08:18 GMT
Content-Length: 49

{"code":602,"message":"body in body is required"}
```


### Python Implementation

- [Validate](server_python.md#validate-api-definition) modified API Definition
- [Generate](server_python.md#generate-server) server using modified API definition

Add module `request_id.py` that provides functions to include as part of

- `before_request`
- `after_request`
- `errorhandler`

```python
import uuid

import flask
from werkzeug.datastructures import Headers, MultiDict


REQ_HEADER = 'X-Request-Id'


def get_or_create_request_id():
    # check if the header was provided
    headers = flask.request.headers
    req_id = headers.get(REQ_HEADER)
    if req_id:
        return req_id

    # else just generate a new one
    return uuid.uuid4()


def request_id():
    if not getattr(flask.g, 'request_id', None):
        flask.g.request_id = get_or_create_request_id()

    return flask.g.request_id


def set_request_id(resp):
    # Some libraries, like OAuthlib, set resp.headers to non Multidict
    # objects (Werkzeug Headers work as well). This is a problem because
    # headers allow repeated values.
    if (not isinstance(resp.headers, Headers)
           and not isinstance(resp.headers, MultiDict)):
        resp.headers = MultiDict(resp.headers)

    if not resp.headers.get(REQ_HEADER):
        resp.headers.add(REQ_HEADER, reqest_id())

    return resp


def add_after_request_reqid_wrapper(app):
    reqid_func = set_request_id
    app.after_request(reqid_func)

    # Wrap exception handlers with reqid_func
    # These error handlers will still respect the behavior of the route
    def _after_request_decorator(f):
        def wrapped_function(*args, **kwargs):
            return reqid_func(app.make_response(f(*args, **kwargs)))
        return wrapped_function

    if hasattr(app, 'handle_exception'):
        app.handle_exception = _after_request_decorator(
            app.handle_exception)
        app.handle_user_exception = _after_request_decorator(
            app.handle_user_exception)
```


Modify `__main__.py` to add hooks

```python
#!/usr/bin/env python3

import connexion
from .encoder import JSONEncoder
from .request_id import add_after_request_reqid_wrapper, request_id


app = connexion.App(__name__, specification_dir='./swagger/')
app.app.json_encoder = JSONEncoder
app.add_api('swagger.yaml', arguments={'title': 'This application implements a very simple issue tracker. '})

application = app.app

@application.before_request
def before():
    # do not return the value as that will trigger an exception
    request_id()


add_after_request_reqid_wrapper(application)


if __name__ == '__main__':
    app.run(port=8080)
```

- [Build](server_python.md#build-server) server using modified API definition
- [Run](server_python.md#run-server) server using modified API definition


#### Example Requests and Responses

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 17
X-Request-Id: 50e56c30-7e15-4c4b-ae83-9cf0ed6434fd
Server: Werkzeug/0.12.2 Python/3.6.3
Date: Tue, 10 Oct 2017 17:21:51 GMT

"do some magic!"
```

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 17
X-Request-Id: 6ba2cd8d-d548-41b6-8b5c-98cc45af2313
Server: Werkzeug/0.12.2 Python/3.6.3
Date: Tue, 10 Oct 2017 17:22:28 GMT

"do some magic!"
```

**Request**

```bash
curl -D - -s -X PUT localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.0 400 BAD REQUEST
Content-Type: application/problem+json
Content-Length: 115
X-Request-Id: a3677a78-00ac-4e56-858f-44f29f26aaba
Server: Werkzeug/0.12.2 Python/3.6.3
Date: Tue, 10 Oct 2017 17:23:04 GMT

{
  "detail": "None is not of type 'object'",
  "status": 400,
  "title": "Bad Request",
  "type": "about:blank"
}
```
