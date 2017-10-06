## Understanding REST

Representational State Transfer (REST) architectural style for distributed hypermedia systems,
describing the software engineering principles guiding REST and the interaction constraints chosen
to retain those principles.

Credit: [REST Source](http://www.restapitutorial.com/)

The constraints of REST.

1. [Uniform Interface](#uniform-interface)
2. [Stateless](#stateless)
3. [Cacheable](#cacheable)
4. [Client-Server](#client-server)
5. [Layered System](#layered-system)


### Uniform Interface

The uniform interface constraint defines the interface between clients and servers. It simplifies
and decouples the architecture, which enables each part to evolve independently.

Guiding Principles

- Resource Based
- Manipulation of Resources Through Representations
- Self-descriptive Messages
- Hypermedia as the Engine of Application State (HATEOAS)


### Stateless

As REST is an acronym for REpresentational State Transfer, statelessness is key.
Essentially, what this means is that the necessary state to handle the request is contained
within the request itself, whether as part of the URI, query-string parameters, body, or headers.
The URI uniquely identifies the resource and the body contains the state (or state change)
of that resource. Then after the server does it's processing, the appropriate state, or the
piece(s) of state that matter, are communicated back to the client via headers, status and
response body.


### Cacheable

As on the World Wide Web, clients can cache responses. Responses must therefore, implicitly
or explicitly, define themselves as cacheable, or not, to prevent clients reusing stale or
inappropriate data in response to further requests. Well-managed caching partially or completely
eliminates some client–server interactions, further improving scalability and performance.


### Client-Server

The uniform interface separates clients from servers. This separation of concerns means that,
for example, clients are not concerned with data storage, which remains internal to each server,
so that the portability of client code is improved. Servers are not concerned with the user
interface or user state, so that servers can be simpler and more scalable. Servers and clients
may also be replaced and developed independently, as long as the interface is not altered.


### Layered System

A client cannot ordinarily tell whether it is connected directly to the end server, or to an
intermediary along the way. Intermediary servers may improve system scalability by enabling
load-balancing and by providing shared caches. Layers may also enforce security policies.
