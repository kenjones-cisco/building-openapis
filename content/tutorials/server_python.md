## Generate API Server (Python)

### Summary

This tutorial will explain how to generate an API server in python using an API definition.

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
  "packageName": "server",
  "hideGenerationTimestamp": true,
  "sortParamsByRequiredFlag": true,
  "ensureUniqueParams": true
}
```


```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli generate \
    -i task-tracker-api.yaml \
    --lang python-flask \
    -c codegen_config.json
```


Output:
```
[main] INFO io.swagger.parser.Swagger20Parser - reading from task-tracker-api.yaml
[main] INFO io.swagger.codegen.ignore.CodegenIgnoreProcessor - No .swagger-codegen-ignore file found.
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/models/task.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/models/user.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/controllers/default_controller.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/test/test_default_controller.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./README.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./setup.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./tox.ini
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test-requirements.txt
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./requirements.txt
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./git_push.sh
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.gitignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.travis.yml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./Dockerfile
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.dockerignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/__main__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/encoder.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/util.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/controllers/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/models/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/models/base_model_.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/test/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./server/swagger/swagger.yaml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen-ignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.swagger-codegen/VERSION
```


Files:
```
./.dockerignore
./.gitignore
./.swagger-codegen
./.swagger-codegen/VERSION
./.swagger-codegen-ignore
./.travis.yml
./codegen_config.json
./Dockerfile
./git_push.sh
./README.md
./requirements.txt
./server
./server/controllers
./server/controllers/default_controller.py
./server/controllers/__init__.py
./server/encoder.py
./server/models
./server/models/base_model_.py
./server/models/task.py
./server/models/user.py
./server/models/__init__.py
./server/swagger
./server/swagger/swagger.yaml
./server/test
./server/test/test_default_controller.py
./server/test/__init__.py
./server/util.py
./server/__init__.py
./server/__main__.py
./setup.py
./task-tracker-api.yaml
./test-requirements.txt
./tox.ini
```


### Build Server

```bash
docker build --tag tracker-pylocal .
```


### Run Server

```bash
docker run -d --rm -p 8080:8080 tracker-pylocal
```


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
Server: Werkzeug/0.12.2 Python/3.6.3
Date: Tue, 10 Oct 2017 17:23:04 GMT

{
  "detail": "None is not of type 'object'",
  "status": 400,
  "title": "Bad Request",
  "type": "about:blank"
}
```
