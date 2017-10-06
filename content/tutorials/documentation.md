## Generate API Documentation

### Summary

This tutorial will explain how to generate documentation using an API definition.

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


### Generate HTML Documentation

```bash
docker run --rm -v ${PWD}:/local -w /local swaggerapi/swagger-codegen-cli generate \
    -i task-tracker-api.yaml \
    -l html \
    -o /local/docs
```


Output:
```
[main] INFO io.swagger.parser.Swagger20Parser - reading from task-tracker-api.yaml
[main] WARN io.swagger.codegen.ignore.CodegenIgnoreProcessor - Output directory does not exist, or is inaccessible. No file (.swager-codegen-ignore) will be evaluated.
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/docs/index.html
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/docs/.swagger-codegen-ignore
[main] INFO io.swagger.codegen.AbstractGenerator - writing file /local/docs/.swagger-codegen/VERSION
```


Files:
```
./docs
./docs/.swagger-codegen
./docs/.swagger-codegen/VERSION
./docs/.swagger-codegen-ignore
./docs/index.html
./task-tracker-api.yaml
```


### Generate Markdown Documentation

Filename: `config.properties`

```
swagger2markup.markupLanguage=MARKDOWN
```


```bash
docker run --rm -v ${PWD}:/local -w /local swagger2markup/swagger2markup convert \
    -i task-tracker-api.yaml \
    -c config.properties \
    -d /local/docs
```


Output:
```
01:06:16.904 [main] INFO  io.swagger.parser.Swagger20Parser - reading from /local/task-tracker-api.yaml
01:06:17.292 [main] DEBUG i.g.s.i.document.PathsDocument - Generate examples is disabled.
01:06:17.292 [main] DEBUG i.g.s.i.document.PathsDocument - Create separated operation files is disabled.
01:06:17.293 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Create separated definition files is disabled.
01:06:17.335 [main] INFO  i.g.s.m.b.i.markdown.MarkdownBuilder - Markup document written to: /local/docs/overview.md
01:06:17.417 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'createTask' (normalized id = 'createTask')
01:06:17.421 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'listTasks' (normalized id = 'listTasks')
01:06:17.423 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'viewTask' (normalized id = 'viewTask')
01:06:17.425 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'updateTask' (normalized id = 'updateTask')
01:06:17.433 [main] INFO  i.g.s.m.b.i.markdown.MarkdownBuilder - Markup document written to: /local/docs/paths.md
01:06:17.436 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Definition processed : 'Task'
01:06:17.443 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Definition processed : 'User'
01:06:17.456 [main] INFO  i.g.s.m.b.i.markdown.MarkdownBuilder - Markup document written to: /local/docs/definitions.md
01:06:17.463 [main] INFO  i.g.s.m.b.i.markdown.MarkdownBuilder - Markup document written to: /local/docs/security.md
```


Files:
```
./config.properties
./docs
./docs/definitions.md
./docs/overview.md
./docs/paths.md
./docs/security.md
./task-tracker-api.yaml
```


### Generate AsciiDoc Documentation

Filename: `config.properties`

```
swagger2markup.markupLanguage=ASCIIDOC
```


```bash
docker run --rm -v ${PWD}:/local -w /local swagger2markup/swagger2markup convert \
    -i task-tracker-api.yaml \
    -c config.properties \
    -d /local/docs
```


Output:
```
01:08:52.218 [main] INFO  io.swagger.parser.Swagger20Parser - reading from /local/task-tracker-api.yaml
01:08:52.671 [main] DEBUG i.g.s.i.document.PathsDocument - Generate examples is disabled.
01:08:52.671 [main] DEBUG i.g.s.i.document.PathsDocument - Create separated operation files is disabled.
01:08:52.672 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Create separated definition files is disabled.
01:08:52.968 [main] INFO  i.g.s.m.b.i.asciidoc.AsciiDocBuilder - Markup document written to: /local/docs/overview.adoc
01:08:53.098 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'createTask' (normalized id = 'createTask')
01:08:53.108 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'listTasks' (normalized id = 'listTasks')
01:08:53.132 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'viewTask' (normalized id = 'viewTask')
01:08:53.146 [main] DEBUG i.g.s.i.document.PathsDocument - Operation processed : 'updateTask' (normalized id = 'updateTask')
01:08:53.157 [main] INFO  i.g.s.m.b.i.asciidoc.AsciiDocBuilder - Markup document written to: /local/docs/paths.adoc
01:08:53.161 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Definition processed : 'Task'
01:08:53.203 [main] DEBUG i.g.s.i.document.DefinitionsDocument - Definition processed : 'User'
01:08:53.230 [main] INFO  i.g.s.m.b.i.asciidoc.AsciiDocBuilder - Markup document written to: /local/docs/definitions.adoc
01:08:53.239 [main] INFO  i.g.s.m.b.i.asciidoc.AsciiDocBuilder - Markup document written to: /local/docs/security.adoc
```


Files:
```
./config.properties
./docs
./docs/definitions.adoc
./docs/overview.adoc
./docs/paths.adoc
./docs/security.adoc
./task-tracker-api.yaml
```


Optionally convert generated AsciiDoc file(s) and any other custom AsciiDoc file(s) to `html5`

Filename: `docs/index.adoc`

```
include::overview.adoc[]
include::security.adoc[]
include::paths.adoc[]
include::definitions.adoc[]
```


```bash
docker run --rm -v ${PWD}:/local -w /local asciidoctor/docker-asciidoctor asciidoctor -v \
    -a doctype=book \
    -b html5 \
    -D content /local/docs/index.adoc
```

Output: N/A

Files:
```
./config.properties
./content
./content/index.html
./docs
./docs/definitions.adoc
./docs/index.adoc
./docs/overview.adoc
./docs/paths.adoc
./docs/security.adoc
./task-tracker-api.yaml
```
