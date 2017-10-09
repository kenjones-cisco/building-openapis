## Generate API Client (Java)

### Summary

This tutorial will explain how to generate an API client in java using an API definition.

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


### Generate Client

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
    --lang java \
    -c codegen_config.json
```


Output:
```
[main] INFO io.swagger.parser.Swagger20Parser - reading from task-tracker-api.yaml
[main] INFO io.swagger.codegen.ignore.CodegenIgnoreProcessor - No .swagger-codegen-ignore file found.
[main] INFO io.swagger.codegen.DefaultCodegen - Invoker Package Name, originally not set, is now dervied from api package name: com.example.tracker
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/model/Task.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/Task.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/model/User.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/User.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/api/DefaultApi.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/test/java/com/example/tracker/api/DefaultApiTest.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/DefaultApi.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./pom.xml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./README.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./build.gradle
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./build.sbt
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./settings.gradle
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./gradle.properties
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/AndroidManifest.xml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.travis.yml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ApiClient.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/StringUtil.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/auth/HttpBasicAuth.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/auth/ApiKeyAuth.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/auth/OAuth.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/auth/OAuthFlow.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./gradlew
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./gradlew.bat
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./gradle/wrapper/gradle-wrapper.properties
[main] INFO io.swagger.codegen.DefaultGenerator - writing file /local/./gradle/wrapper/gradle-wrapper.jar
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./git_push.sh
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.gitignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ApiException.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/Configuration.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/Pair.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/auth/Authentication.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ApiCallback.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ApiResponse.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/JSON.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ProgressRequestBody.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/ProgressResponseBody.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./src/main/java/com/example/tracker/GzipRequestInterceptor.java
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen-ignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen/VERSION
```


Files:
```
./.gitignore
./.swagger-codegen
./.swagger-codegen/VERSION
./.swagger-codegen-ignore
./.travis.yml
./build.gradle
./build.sbt
./codegen_config.json
./docs
./docs/DefaultApi.md
./docs/Task.md
./docs/User.md
./git_push.sh
./gradle
./gradle/wrapper
./gradle/wrapper/gradle-wrapper.jar
./gradle/wrapper/gradle-wrapper.properties
./gradle.properties
./gradlew
./gradlew.bat
./pom.xml
./README.md
./settings.gradle
./src
./src/main
./src/main/AndroidManifest.xml
./src/main/java
./src/main/java/com
./src/main/java/com/example
./src/main/java/com/example/tracker
./src/main/java/com/example/tracker/api
./src/main/java/com/example/tracker/api/DefaultApi.java
./src/main/java/com/example/tracker/ApiCallback.java
./src/main/java/com/example/tracker/ApiClient.java
./src/main/java/com/example/tracker/ApiException.java
./src/main/java/com/example/tracker/ApiResponse.java
./src/main/java/com/example/tracker/auth
./src/main/java/com/example/tracker/auth/ApiKeyAuth.java
./src/main/java/com/example/tracker/auth/Authentication.java
./src/main/java/com/example/tracker/auth/HttpBasicAuth.java
./src/main/java/com/example/tracker/auth/OAuth.java
./src/main/java/com/example/tracker/auth/OAuthFlow.java
./src/main/java/com/example/tracker/Configuration.java
./src/main/java/com/example/tracker/GzipRequestInterceptor.java
./src/main/java/com/example/tracker/JSON.java
./src/main/java/com/example/tracker/model
./src/main/java/com/example/tracker/model/Task.java
./src/main/java/com/example/tracker/model/User.java
./src/main/java/com/example/tracker/Pair.java
./src/main/java/com/example/tracker/ProgressRequestBody.java
./src/main/java/com/example/tracker/ProgressResponseBody.java
./src/main/java/com/example/tracker/StringUtil.java
./src/test
./src/test/java
./src/test/java/com
./src/test/java/com/example
./src/test/java/com/example/tracker
./src/test/java/com/example/tracker/api
./src/test/java/com/example/tracker/api/DefaultApiTest.java
./task-tracker-api.yaml
```

