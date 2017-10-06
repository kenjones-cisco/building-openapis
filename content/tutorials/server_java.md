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

```
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

