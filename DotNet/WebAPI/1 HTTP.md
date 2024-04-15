
# HTTP (HyperText Transport Protocol)

HTTP stands for **Hypertext Transfer Protocol**. It is the foundation for exchanging information between a web server and a client on the Web. HTTP defines the format for messages (requests and responses) between the Clients and Server.

- **Basic Function:** HTTP is a request-response protocol typically used in client-server computing. The client, often a web browser, makes a request to a server for web resources like HTML pages, images, etc. The server then responds to those requests.
- **Stateless Protocol:** HTTP is stateless, meaning it retains no memory of past transactions. However, mechanisms like cookies and sessions are essential when maintaining a session (like shopping carts on e-commerce sites).
- **Methods:** HTTP includes methods to indicate the desired action on a given resource. These methods include GET (retrieve data), POST (submit data to be processed), PUT (update data), DELETE (remove data), and others.
- **Secure HTTP (HTTPS):** When HTTP is used in conjunction with SSL/TLS, it’s known as HTTPS (Hypertext Transfer Protocol Secure). This adds a layer of encryption, enhancing security, which is especially important for sensitive transactions like online banking.
- **Role in Web Browsing:** When you visit a website, your browser sends HTTP requests to the server hosting the site. The server then responds with HTTP responses that include the requested pages, which are then rendered by your browser.
- **Headers and Responses:** HTTP messages contain a start-line, headers, and an optional body. Headers contain information about the request or response.

##### **How do the Browser and Server Communicate with each other?**

![[word-image-306-768x275.webp]]

#### **HTTP Request Components:**

HTTP (Hypertext Transfer Protocol) is the protocol used for communication between a client (such as a web browser) and a server (such as a web server) over the internet. The client makes an HTTP request to request a resource from the server, and the server responds with an HTTP response containing the requested resource or an error message.

When we send something from the client (browser, mobile, postman, fiddler, etc.) to the server (webserver), it is called a Request. The request is formed with a couple of components. 

1. **URL**: Each Request must have a unique URL.
2. **Verb (Method):** Each Request must have an HTTP Verb. Examples include GET, POST, PUT, PATCH, DELETE, etc.
3. **Header(s):** Each Request can contain one or more Headers.
4. **Body**: Each request can have a body. The body contains the data that we want to send to the server.
![[word-image-307-768x294.webp]]

##### **Start Line**

- **Request Method:** This specifies the action to be performed. Common methods include GET (retrieve data), POST (submit data for processing), PUT (update data), and DELETE (remove data), among others.
- **Request URI (Uniform Resource Identifier):** The URI (usually a URL) identifies the specific resource on the server that the client wants to interact with.
## Request Headers

**Request Headers:** Each HTTP Request can contain one or more Request Headers. The Request Header will be in the form of key-value pairs that provide additional information about the request. Some common headers include:

- **Host**: Specifies the domain name of the server.
- **User-Agent:** Identifies the client software initiating the request (e.g., the browser or application).
- **Accept:**  Tells the server what content types the client can handle.
- **Content-Type:**  When the request includes a body (like a POST, PUT, or PATCH request), this header indicates the media type of the body.
- **Authorization:** Contains credentials for authentication purposes.
- **Cookie:** Includes any cookies that the client has for this domain. This is used for state management.
- **Cache-Control:** Directives for caching mechanisms in both requests and responses.

**Request Body (Optional):** The body of an HTTP request is optional and is used when sending additional data to the server, like in POST, PUT, or PATCH requests. It could contain data from a form submission, file uploads, or JSON/XML data in the case of API requests.

## **HTTP Response Components:**


Whatever the client receives from the web server is called HTTP Response. The HTTP response contains the following components.

1. **HTTP Status Code:** It must have a Status Code indicating the status of the HTTP Request. 200 Indicates successful, 500 indicates internal server error, 404 indicates resource not found, etc.
2. **Response Headers:** It can have one or more response headers.
3. **Data:** Response can have data, i.e., return to the client.

There are also other components. However, the above three components are important in an HTTP Response.![[word-image-308-768x263.webp]]
**Status Line:** The first line of the HTTP response, which includes the following information:

1. **HTTP Version:** Indicates the version of the HTTP protocol used (e.g., HTTP/1.1).
2. **Status Code:** A three-digit number that indicates the outcome of the request. Common examples include 200 (OK), 404 (Not Found), and 500 (Internal Server Error).
3. **Status Text:** A brief, human-readable phrase that provides a description of the status code (e.g., “OK”, “Not Found”).

**Response Headers:** Each HTTP Response can have one or more Response Headers. The Response Header will be in the form of key-value pairs that provide additional information about the response. Some common headers include:

- **Content-Type:** Indicates the media type of the response body (e.g., text/html for HTML documents, application/json for JSON data, application/xml for XML data).
- **Content-Length:** The length of the response body in bytes.
- **Cache-Control:** Directives for caching mechanisms in both requests and responses.
- **Set-Cookie:** Used to send cookies from the server to the user agent.
- **Server:** Information about the software used by the origin server.
- **Date:** The date and time at which the message was sent.

**Response Body**: This part contains the actual content of the response. The nature and format of the response body depend on the request and the server’s capabilities. It could be an HTML document, an image, JSON data, XML data, or plain text.

#### **HTTP Verbs or HTTP Methods:**

###### **GET HTTP Method:**

The GET HTTP Method is used to Retrieve the Data. The HTTP GET method requests a representation of the specified resource. Requests using GET should only be used to request data (they shouldn’t include data). For example, you want to search for something like you want to get a list of employees, a list of products, you want to retrieve a book by ID, etc. So, whenever you expect some data from the server, you need to use GET HTTP Verb. So, it retrieves a representation of a resource without modifying it.

###### **POST HTTP Method:**

The HTTP POST request is used to make a new entry in the database. It is not only specific to a database; whenever you want to create a new resource in your application, you must use the POST method. It often results in the creation of a new resource. What does it mean to add a new Resource? It means if you want to add a new employee or a new product, the main concept is not the database; the main concept is adding a new resource.

###### **PUT HTTP Method:**

The HTTP PUT request is used to update all the properties of the current resource in the database. What does it mean? For example, we have a table called Product in our database. If we want to update all properties of a particular product, then we need to use PUT HTTP Request. So, you need to use the PUT Method whenever you want to update all the properties (columns) of a resource (existing record in the database). You cannot add a new resource using the PUT method.

###### **PATCH HTTP Method:**

###### **PATCH HTTP Method:**

In some situations, you don’t want to update all the properties of an existing resource; instead, you want to update a few of the properties of an existing resource; then, in that case, you need to use the PATCH method. So, the PATCH method is similar to the PUT method but is used to update a few resource properties. For example, if you want to update a few properties (columns) of an existing product, then you need to use the PATCH method. That means if your Product table contains 10 columns, and you want to update only four columns of an existing product, then you need to use the PATCH method.

###### **DELETE HTTP Method:**

The DELETE method is used to delete the resource from the database. It removes a specified resource. That means you are removing or deleting an existing entity from your database. In modern applications, we use two concepts for deletion. One is Soft Delete, and the other one is Hard Delete.

1. **Soft Delete:** In your table, if you have some column like IsDeleted or IsActive or something similar to this and you want to update that column, then you cannot use the Delete Method. In that case, you need to use the PATCH method. This is because you are not deleting the record from the database; you are simply updating the record.
2. **Hard Delete:** If you want to remove the existing entity from the table, then you need to use the DELETE method. For example, Delete an existing product from the Product table in the database, etc.

#### **HTTP Status Codes:**

The HTTP status code is also one of the important components of HTTP Response. The Status code is issued from the server, and they give information about the response. Whenever the client gets any response from the server, we must have one HTTP Status code in that HTTP Response.

1. **1XX**: **Informational Response (Example: 100, 101, 102, etc.)**. Status codes in the 1xx range indicate that the server has received the client’s request and is continuing the process. These codes are primarily used for informational purposes and do not typically require any action from the client.
2. **2XX**: **Successful Response (Example. 200, 201, 203, 204, etc.).** Whenever you get 2XX as the response code, it means the request is successful. Status codes in the 2xx range indicate that the server successfully received, understood, and accepted the client’s request. These codes typically indicate that the requested action was successfully completed.
3. **3XX**: **Redirection Response (Example. 301, 302, 304, etc.)**. Whenever you get 3XX as the response code, it means it is re-directional, i.e., some re-directional is happening on the server.  Status codes in the 3xx range indicate that the client needs further action to complete the request. These codes are used when a resource has been moved or is temporarily unavailable, and the client needs to take additional steps to access the resource.
4. **4XX**: **Client Error Response (Example: 400, 401, 404, 405, etc.)**. Whenever you get 4XX as the response code, it means there is some problem with your request.  Status codes in the 4xx range indicate that the client’s request was unsuccessful due to an error on the client’s side. These codes are often associated with issues such as invalid requests, unauthorized access, or missing resources.
5. **5XX**: **Server Error Response (Example: 500, 502, 503, 504, etc.)**. Whenever you get 5XX as the response code, it means there is some problem in the server. Status codes in the 5xx range indicate that the server encountered an error while processing the client’s request. These codes are typically associated with issues on the server side, indicating that the requested action could not be completed due to server-related problems.
##### **Frequently used HTTP Status Codes:**

In Web API development, HTTP status codes are an essential part of the response sent by the server to indicate the outcome of a client’s request. Here are some of the frequently used HTTP status codes in Web APIs:

1. **100: 100 means Continue.**
2. **200: 200 means OK.** The HTTP 200 OK success status response code indicates that the request has been successfully processed, and the server is returning the requested resource in the response body.
3. **201: 201 means a new resource created.** The HTTP 201 Created success status response code indicates that the request has succeeded and led to the creation of a resource. If you are successfully adding a new resource by using the HTTP Post method, then in that case, you will get 201 as the Status code.
4. **204: 204 means No Content.** The HTTP 204 No Content success status response code indicates that a request has succeeded but is not returning any content to the client. That means this status code indicates that the server has successfully processed the request but has no content to return in the response body.
5. 1. **301: 301 means Moved Permanently.** If you are getting 301 as a status response code from the server, it means the resource you are looking for is moved permanently to the URL given by the Location headers.
6. 1. **302: 302 means Found.** If you are getting 302 as a status response code from the server, it means the resource you are looking for is moved temporarily to the URL given by the Location headers.
7. **400: 400 means Bad Request.** If you are getting 400 as the status code from the server, then the issue is with the client’s request. Suppose the request contains wrong data, such as malformed request syntax, invalid request message, missing required parameters, and invalid data.
8. **401: 401 means Unauthorized.** If you are trying to access the resource you don’t have access to (Invalid Authentication Credentials), you will get a 401 unauthorized status code from the server.
9. **403: 403  means Forbidden:** This status code is similar to 401, but it indicates that the client is authenticated but has insufficient permissions to access the requested resource.
10.  1. **404: 404 means Not Found.** If you are looking for a resource that does not exist, then you will get this 404 Not Found status code from the server. Links that lead to a 404 page are often called broken or dead links. That means this status code is used when the server cannot find the requested resource. It indicates that the URI is not recognized or the resource does not exist.
11. **405: 405 means Method Not Allowed.** The 405 Method Not Allowed response status code indicates that the server knows the request method but is not supported by the target resource.
12. **500: 500 means Internal Server Error.** If there is some error in the server, then you will get a 500 Internal Server Error Response status code. That means this status code indicates an unexpected error occurred on the server while processing the request.
13. **503: 503 means Service Unavailable.** The 503 Service Unavailable server error response code indicates that the server is not ready to handle the request. If the server is down for maintenance or overloaded, then you will get the 503 Service Unavailable Status code.
14. **504: 504 means Gateway Timeout.** The 504 Gateway Timeout server error response code indicates that the server while acting as a gateway or proxy, did not get a response in time from the upstream server needed to complete the request.
15. 

