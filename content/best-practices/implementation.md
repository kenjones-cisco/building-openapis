# Implementation Best Practices

### Instrumentation

Instrument your server code, with the most important aspects being the capture of every request
and corresponding response. If you make calls to other services using their API then capture the
request and response those calls.

!!! warning
    Be sure to mask sensitive data elements. e.g. Credit Card numbers, passwords, etc.

As part of this instrumentation, at the start of each request generate a unique id to associate
with each log message related to that request. It is strongly recommended to include the same
unique id as part of the response back to the caller. If there is an error or other issue, then
the user can provide that id which can be used to find the logs associated with their specific
request for easier problem resolution. The unique id is also referred to as [CorrelationID](http://theburningmonk.com/2015/05/a-consistent-approach-to-track-correlation-ids-through-microservices/) :fa-external-link:.

The logs should be published to a central logging service like ELK or Splunk.


### Capture Metrics

Capture metrics about request processing to help identify bottle necks, hot zones, and impacts
based on recent changes. First establish the types of metrics relevant for your application.
Most common is total time processing time for a request, request successful or failed and total
processing time for requests made to external services.

There are multiple different ways to capture the metrics. Publish using client (prometheus),
extract from logging service (elk) or use service like AppDynamics to name a few.


### Health Checks

Provide an API endpoint for health check (/health). The response should be a status 200 if healthy.
For degraded or unhealthy select the most appropriate based on your selected monitors (4xx or 5xx).
The implementation of your health check will vary based on what is relevant for you application.
It can be as simple as returning status 200 to indicate the server process is up and able to respond.
If you have dependency on external resources then checking if they are all fully operational
is recommended.


### Monitoring and Alerting

You should having monitoring and alerting of your logs (on error or N errors within X period of time, etc.),
on your metrics (response times greater than threshold), and on your health (on degraded or unhealthy
or no response within X period of time).

The notifications can be done in multiple different approaches, for example emails, text messages,
dashboard alerts, published events, and message on collaboration platform.


### Synthetic Transactions

Synthetic transactions are actions, run in real time, that are performed on monitored API endpoints.
You can use synthetic transactions to measure the performance of a monitored API endpoint.

Automated execution of 1 or more APIs that exercise the functionality of the APIs within the
production system at a set interval. Ideal for GET and for resources that have full CRUD support
(POST/GET/PUT/PATCH/DELETE).

These transactions serve the purpose to validate your APIs are functional. Continue to generate
metrics for your APIs on a reoccurring interval even if users / clients are not currently using a
specific API. Also the continued use of the APIs allows you to proactively identify outages,
performance degradation, and other possible issues as the Monitoring and Alerting will send
notifications when issues arise.

Similar to [Synthetic Monitoring](https://en.wikipedia.org/wiki/Synthetic_monitoring) :fa-external-link: used on web based applications.
