# API Design Standards & Best Practices

Credit:

- [A RESTful Tutorial](http://www.restapitutorial.com/)
- [10 Best Practices for Better RESTful API](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/)
- [Best Practices for Designing a Pragmatic RESTful API](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)
- [Best Practice: API Versioning for HTTP REST Interfaces](https://www.suse.com/communities/blog/best-practice-api-versioning-http-rest-interfaces/)


#### Resources

Producing a great API is 80% art and 20% science. Creating a URL hierarchy representing sensible
resources is the art part. Having sensible resource names (which are just URL paths, such as
/customers/12345/orders) improves the clarity of what a given request does.

- Resource names should be **nouns**; avoid **verbs** as resource names.
- Use **plurals** in URL segments to keep your API URIs consistent across all HTTP methods, using the collection metaphor.
- Avoid using collection verbiage in URLs. For example 'customer_list' as a resource. Use pluralization to indicate the collection metaphor (e.g. customers vs. customer_list).
- Use lower-case in URL segments, separating words with underscores `_` or hyphens `-`. Some servers ignore case so it's best to be clear.
- Use identifiers in your URLs instead of in the query-string. Using URL query-string parameters is fantastic for filtering, but not for resource names.
- Design for your clients, not for your data.
- Leverage the hierarchical nature of the URL to imply structure (relationships). e.g. /customers/1107/orders
- Keep URLs as short as possible, with as few segments as makes sense. **Recommend**: Max of 3 levels deep


#### Status Codes

Response status codes are part of the HTTP specification. There are quite a number of them to
address the most common situations. In the spirit of having our RESTful services embrace the HTTP
specification, our Web APIs should return relevant HTTP status codes.

Most common HTTP Response Status Codes

| Status Code | Description |
| :---: | --- |
| 200 OK | General success status code. This is the most common code. Used to indicate success. |
| 201 CREATED | Successful creation occurred. Set the Location header to contain a link to the newly-created resource. Response body content may or may not be present. |
| 204 NO CONTENT | Indicates success but nothing is in the response body, often used for DELETE and PUT operations. |
| 400 BAD REQUEST | General error for when fulfilling the request would cause an invalid state. Domain validation errors, missing data, etc. are some examples. |
| 401 UNAUTHORIZED | Error code response for missing or invalid authentication token. |
| 403 FORBIDDEN | Error code for when the user is not authorized to perform the operation or the resource is unavailable for some reason (e.g. time constraints, etc.). |
| 404 NOT FOUND | Used when the requested resource is not found, whether it doesn't exist or if there was a 401 or 403 that, for security reasons, the service wants to mask. |
| 405 METHOD NOT ALLOWED | Used to indicate that the requested URL exists, but the requested HTTP method is not applicable. The Allow HTTP header must be set when returning a 405 to indicate the HTTP methods that are supported. |
| 409 CONFLICT | Whenever a resource conflict would be caused by fulfilling the request. |
| 500 INTERNAL SERVER ERROR | Never return this intentionally. The general catch-all error when the server-side throws an exception. Use this only for errors that the consumer cannot address from their end. |


#### Methods

Methods on resources should be defined using standard HTTP verbs

| HTTP Verb | CRUD | Entire Collection (e.g. /customers) | Specific Item (e.g. /customes/{id}) |
| :---: | :---: | --- | --- |
| POST | Create | 201 (Created), 'Location' header with link to /customers/{id} containing new ID. | 404 (Not Found), 409 (Conflict) if resource already exists. |
| GET | READ | 200 (OK), list of customers. Use pagination, sorting, and filtering to navigate big lists. | 200 (OK), single customer, 404 (Not Found), if ID not found or invalid. |
| PUT | Update/Replace | 405 (Method Not Allowed) | 200 (OK) or 204 (No Content), 404 (Not Found), if ID not found or invalid. |
| PATCH | Update/Modify | 405 (Method Not Allowed) | 200 (OK) or 204 (No Content), 404 (Not Found), if ID not found or invalid. |
| DELETE | Delete | 405 (Method Not Allowed) | 200 (OK), 404 (Not Found), if ID not found or invalid. |

!!! note
    GET requests must not change any underlying resource data.


#### Errors

All errors should return a payload with details about the error.

Minimal attributes of the error payload

- message: Useful message about the cause of the error
- code: An identifier that can be used to get additional information.


#### Formats

All APIs should support JSON formats by default. Optionally support other formats, e.g. XML.

Use HTTP Header to specify serialzation formats.

    *Content-Type* defines the request format.
    *Accept* defines a list of acceptable response formats.


#### Filtering, Sorting, Field Selection & Pagination

When performing GET on a collection clients will need the ability to filter, sort, paginate, and/or limit fields in the results.

**Filtering**

Use a unique query parameter for all fields or a query language for filtering.

```
GET /cars?color=red
GET /cars?seats<=2
```


**Sorting**

Allow ascending and descending sorting over multiple fields.

```
GET /cars?sort=-manufactorer,+model
```


**Field Selection**

Mobile clients display just a few attributes in a list. They don’t need all attributes of a resource.
Give the API consumer the ability to choose returned fields. This will also reduce the network traffic
and speed up the usage of the API.

```
GET /cars?fields=manufacturer,model,id,color
```


**Paging**

Use limit and offset. It is flexible for the user and common in leading databases.

```
GET /cars?offset=10&limit=5
```

Use the HTTP Header `Link` to return a set of ready-made links.

```
Link: <https://api.github.com/user/repos?page=3&per_page=100>; rel="next", <https://api.github.com/user/repos?page=50&per_page=100>; rel="last"
```

An API that requires sending a count can use a custom HTTP header like `X-Total-Count`.


#### Versioning

Always version your API. Use [Semantic Versioning](http://semver.org/) for defining versions.

The major version should be included in the URL.

```
/blog/api/v1
```

Use HTTP content type negotiation to expose minor verions. Leverage the versioned vnd content types.

There is an [HTTP RFC 6838](https://tools.ietf.org/html/rfc6838#section-3.2) for custom vendor-specific MIME types.
It reserves a whole “vendor tree”, with free-form entries looking like type/vnd.producer’s name followed
by media type name [+suffix]


```
application/vnd.crowbar.v2.3+json
```


In this case, the major version provides structural stability of the API as a whole while the
minor versions accounts for smaller changes (field deprecations, endpoint changes, etc).


#### Security

Always use SSL. No exceptions.

Use [OAuth2](https://oauth.net/2/) for authentication. The defacto industry standard for APIs.


#### Caching

HTTP provides a built-in caching framework! All you have to do is include some additional outbound
response headers and do a little validation when you receive some inbound request headers.

There are 2 approaches: [ETag](http://en.wikipedia.org/wiki/HTTP_ETag) and [Last-Modified](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.29)

**ETag**: When generating a response, include a HTTP header `ETag` containing a hash or checksum of the
representation. This value should change whenever the output representation changes. Now, if an
inbound HTTP requests contains a `If-None-Match` header with a matching ETag value, the API should
return a `304 Not Modified` status code instead of the output representation of the resource.

**Last-Modified**: This basically works like to ETag, except that it uses timestamps. The response
header `Last-Modified` contains a timestamp in [RFC 1123](http://www.ietf.org/rfc/rfc1123.txt) format
which is validated against `If-Modified-Since`. Note that the HTTP spec has had 3 different
acceptable date formats and the server should be prepared to accept any one of them.
