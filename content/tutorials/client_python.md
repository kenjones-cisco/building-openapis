## Generate API Client (Python)

### Summary

This tutorial will explain how to generate an API client in python using an API definition.

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

```
{
  "packageName": "client",
  "projectName": "trackerapi",
  "hideGenerationTimestamp": true,
  "sortParamsByRequiredFlag": true
}
```


```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli generate \
    -i task-tracker-api.yaml \
    --lang python \
    -c codegen_config.json
```


Output:
```
[main] INFO io.swagger.parser.Swagger20Parser - reading from task-tracker-api.yaml
[main] INFO io.swagger.codegen.ignore.CodegenIgnoreProcessor - No .swagger-codegen-ignore file found.
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/models/task.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test/test_task.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/Task.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/models/user.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test/test_user.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/User.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/apis/default_api.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test/test_default_api.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./docs/DefaultApi.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./README.md
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./tox.ini
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test-requirements.txt
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./requirements.txt
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/configuration.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/models/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/apis/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./test/__init__.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./git_push.sh
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.gitignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./.travis.yml
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./setup.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/api_client.py
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/./client/rest.py
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
./client
./client/apis
./client/apis/default_api.py
./client/apis/__init__.py
./client/api_client.py
./client/configuration.py
./client/models
./client/models/task.py
./client/models/user.py
./client/models/__init__.py
./client/rest.py
./client/__init__.py
./codegen_config.json
./docs
./docs/DefaultApi.md
./docs/Task.md
./docs/User.md
./git_push.sh
./README.md
./requirements.txt
./setup.py
./task-tracker-api.yaml
./test
./test/test_default_api.py
./test/test_task.py
./test/test_user.py
./test/__init__.py
./test-requirements.txt
./tox.ini
```

