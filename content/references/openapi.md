## OpenAPI based Definitions

Define your API using [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification).

The specification provides a standard for describing interoperable REST APIs based on Resources
and HTTP. The result is a definition that is human and machine consumable. Standards make it
machine consumable and the simplicity makes it easy enough for developers to document and
learn the API.

Humans use the definition as a source of API documentation, examples, and as a guide to try out
and understand the capabilities of the API. Ease of use is the key factor for success.

Three common use-cases for using [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification) to define the APIs within your application.

Credit: [Scenario Source](https://www.openapis.org/blog/2017/09/26/three-common-scenarios-for-leveraging-the-openapi-specification)

1. [Legacy API](#legacy-api)
2. [Design First](#design-first)
3. [Server First](#server-first)


### Legacy API

The first scenario covers services and APIs that are already in production. Adding an OpenAPI
document will formally capture the signature of the API in a standardized way. Therefore, consumers
can use this API definition as documentation to easily integrate with your API.

As long as you are using HTTP or HTTPS with JSON or XML encoding, it doesn’t matter what language
or framework you choosed for the implementation: you have an interoperable API awaiting to be
discovered by the world.

The best thing here that surprise many people is: **you don’t have to change a single bit of your
running API or service**. The metadata provided by the OpenAPI Spec is a definition stored in a
self-contained file (YAML or JSON) you can share offline (as a file) or publish in any web server.


### Design First

Parallel development by the API provider and the API consumer(s) is made possible because all teams
share an API definition. The API definition can be edited and validated with no language or
implementation assumptions, thereby making the API fully interoperable.

OpenAPI and the related ecosystem of tools provide the ability to use the API definition to view
documentation, validate the API, generate server code stubs, and generate client code.

Each team will leverage the tools to generate server stubs, and proxies for the client in any
supported language or platform.

This is the recommended approach for long term success of producing high quality APIs. The one major
challenge to this approach is that the main API functionality needs to be understood enough in order
to create the API definition first.

In the long term you will maintain and evolve the definition in a planned manner including a well
defined versioning strategy. See [Semantic Versioning](http://semver.org/) for to guide the versioning strategy.


### Server First

Development of the API implementation starts, typically as a method of quickly prototyping an idea,
when the domain or functionality is not well understood.

This scenario is also supported because it is possible to generate an API definition using reflection
techniques and metadata to discover services, types, and parameters through source code inspection.

Short-term Advantages:

- Auto-generated documentation and definition.
- Definition is always in sync with API implementation.
- Agility in server-side development.


Major Disadvantages:

- Extreme caution and due dilgence required when adding new features could inadvertently breaking existing clients.
- Derived API definitions could lack simplicity or user experience (compared to design first). The optimizations made for automation could be confusing for humans: design for humans.


Only recommended for fast prototyping that is not bound for production. This alleviates the risk of
breaking existing clients. Once the main API functionality is well understood, refactor API definition
for proper user experience and continue with [Design First](#design-first) approach.


## OpenAPI Ecosystem

There is a very large ecosystems that provides tools to make producing and consumes APIs faster and easier!

[Editor](http://editor.swagger.io/) is a powerful editor for designing or editing APIs which visually
renders your API definition with concise, real time feedback and error handling.

[Documentation](https://swagger.io/swagger-ui/) helps you visualize your API resources from its
API definition and generate beautiful, interactive documentation that can be host in any environment.

[Code Generation](https://github.com/swagger-api/swagger-codegen) will use your API definition
to generate server stubs and/or client libraries (SDK) in more than 40 different languages.

[Desktop Client](https://www.getpostman.com/) provides a client that can import your API definition
to generate an instant client for using your APIs.

Plus many more [commercial tools](https://swagger.io/commercial-tools/) and [open source tools](https://swagger.io/open-source-integrations/).

Most of the ecosystem is based on the [OpenAPI Spec v2 (formerly known as Swagger)](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md).
[OpenAPI Spec v3](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md) was released [July 26, 2017](https://www.openapis.org/blog/2017/07/26/the-oai-announces-the-openapi-specification-3-0-0). The tooling will take time to be updated
to supported the latest version. Many of the tool providers have already started work for adding support.

