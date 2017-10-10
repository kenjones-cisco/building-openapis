## Generate API Server (Java)

### Summary

This tutorial will explain how to generate an API server in java using an API definition.

!!! info
    Prerequisite [**Environment Setup**](setup.md)


!!! tip
    - `${PWD}` works on Linux, MacOS, and Windows (via Powershell)
    - `%cd%` works on Windows (via cmd)
    - `$(cygpath -m -a "$(pwd)")` works on Windows (via Cygwin)


### Validate API Definition

```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli validate \
    -i task-tracker-api.yaml
```


### Generate Server

Filename: `codegen_config.json`

```json
{
  "artifactId": "tracker",
  "groupId": "com.example.tracker",
  "basePackage": "com.example.tracker",
  "apiPackage": "com.example.tracker.api",
  "configPackage": "com.example.tracker.config",
  "modelPackage": "com.example.tracker.model",
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


Output:
```
[main] INFO io.swagger.parser.Swagger20Parser - reading from task-tracker-api.yaml
[main] INFO io.swagger.codegen.ignore.CodegenIgnoreProcessor - No .swagger-codegen-ignore file found.
[main] INFO io.swagger.codegen.DefaultCodegen - Invoker Package Name, originally not set, is now dervied from api package name: com.example.tracker
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/model/Task.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/model/User.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/TasksApiController.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/TasksApi.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./pom.xml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./README.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/config/HomeController.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/Swagger2SpringBoot.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/RFC3339DateFormat.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/resources/application.properties
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/ApiException.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/ApiResponseMessage.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/NotFoundException.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/ApiOriginFilter.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/config/SwaggerDocumentationConfig.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen-ignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen/VERSION
```


Files:
```
./.swagger-codegen
./.swagger-codegen/VERSION
./.swagger-codegen-ignore
./codegen_config.json
./pom.xml
./README.md
./src
./src/main
./src/main/java
./src/main/java/com
./src/main/java/com/example
./src/main/java/com/example/tracker
./src/main/java/com/example/tracker/api
./src/main/java/com/example/tracker/api/ApiException.java
./src/main/java/com/example/tracker/api/ApiOriginFilter.java
./src/main/java/com/example/tracker/api/ApiResponseMessage.java
./src/main/java/com/example/tracker/api/NotFoundException.java
./src/main/java/com/example/tracker/api/TasksApi.java
./src/main/java/com/example/tracker/api/TasksApiController.java
./src/main/java/com/example/tracker/config
./src/main/java/com/example/tracker/config/HomeController.java
./src/main/java/com/example/tracker/config/SwaggerDocumentationConfig.java
./src/main/java/com/example/tracker/model
./src/main/java/com/example/tracker/model/Task.java
./src/main/java/com/example/tracker/model/User.java
./src/main/java/com/example/tracker/RFC3339DateFormat.java
./src/main/java/com/example/tracker/Swagger2SpringBoot.java
./src/main/resources
./src/main/resources/application.properties
./task-tracker-api.yaml
```


### Build Server

Create a simple `Dockerfile` to use for running the server. There are multiple different approaches
for compiling the server within a docker image. This is the simplest but there are more efficient
approaches.


Filename: `Dockerfile`

```Dockerfile
FROM maven:3.5-jdk-8

WORKDIR /opt/tracker

COPY pom.xml /opt/tracker/pom.xml
COPY src /opt/tracker/src

RUN mvn -e package -Dmaven.test.skip=true -DskipTests

CMD ["java", "-jar", "/opt/tracker/target/tracker-1.0.0.jar"]
EXPOSE 8080
```


```bash
docker build --tag tracker-javalocal .
```


### Run Server

```bash
docker run -d --rm -p 8080:8080 tracker-javalocal
```


#### Example Requests and Responses

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.1 415
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:24:11 GMT

{"timestamp":"2017-10-10T19:24:11.807Z","status":415,"error":"Unsupported Media Type","exception":"org.springframework.web.HttpMediaTypeNotSupportedException","message":"Content type 'null' not supported","path":"/v1/tasks"}
```

**Request**

```bash
curl -D - -s -H "Content-type: application/json" localhost:8080/v1/tasks
```

**Response**

```http
HTTP/1.1 200
Content-Length: 0
Date: Tue, 10 Oct 2017 19:26:14 GMT

```

**Request**

```bash
curl -D - -s localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 415
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:24:40 GMT

{"timestamp":"2017-10-10T19:24:40.968Z","status":415,"error":"Unsupported Media Type","exception":"org.springframework.web.HttpMediaTypeNotSupportedException","message":"Content type 'null' not supported","path":"/v1/tasks/1"}
```

**Request**

```bash
curl -D - -s -H "Content-type: application/json" localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 400
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:26:56 GMT
Connection: close

{"timestamp":"2017-10-10T19:26:56.527Z","status":400,"error":"Bad Request","exception":"org.springframework.web.method.annotation.MethodArgumentTypeMismatchException","message":"Failed to convert value of type 'java.lang.String' to required type 'java.util.UUID'; nested exception is java.lang.IllegalArgumentException: Invalid UUID string: 1","path":"/v1/tasks/1"}
```

**Request**

```bash
curl -D - -s -H "Content-type: application/json" localhost:8080/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313
```

**Response**

```http
HTTP/1.1 200
Content-Length: 0
Date: Tue, 10 Oct 2017 19:30:04 GMT

```

**Request**

```bash
curl -D - -s -X PUT localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 415
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:25:08 GMT

{"timestamp":"2017-10-10T19:25:08.538Z","status":415,"error":"Unsupported Media Type","exception":"org.springframework.web.HttpMediaTypeNotSupportedException","message":"Content type 'null' not supported","path":"/v1/tasks/1"}
```

**Request**

```bash
curl -D - -s -X PUT -H "Content-type: application/json" localhost:8080/v1/tasks/1
```

**Response**

```http
HTTP/1.1 400
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:29:14 GMT
Connection: close

{"timestamp":"2017-10-10T19:29:14.464Z","status":400,"error":"Bad Request","exception":"org.springframework.web.method.annotation.MethodArgumentTypeMismatchException","message":"Failed to convert value of type 'java.lang.String' to required type 'java.util.UUID'; nested exception is java.lang.IllegalArgumentException: Invalid UUID string: 1","path":"/v1/tasks/1"}
```

**Request**

```bash
curl -D - -s -X PUT -H "Content-type: application/json" localhost:8080/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313
```

**Response**

```http
HTTP/1.1 400
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Tue, 10 Oct 2017 19:30:59 GMT
Connection: close

{"timestamp":"2017-10-10T19:30:59.651Z","status":400,"error":"Bad Request","exception":"org.springframework.http.converter.HttpMessageNotReadableException","message":"Required request body is missing: public default org.springframework.http.ResponseEntity<com.example.tracker.model.Task> com.example.tracker.api.TasksApi.updateTask(java.util.UUID,com.example.tracker.model.Task,java.util.UUID,java.lang.String) throws java.lang.Exception","path":"/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313"}
```

**Request**

```bash
curl -D - -s -X PUT -H "Content-type: application/json" -d '{}' localhost:8080/v1/tasks/6ba2cd8d-d548-41b6-8b5c-98cc45af2313
```

**Response**

```http
HTTP/1.1 200
Content-Length: 0
Date: Tue, 10 Oct 2017 19:32:38 GMT

```
