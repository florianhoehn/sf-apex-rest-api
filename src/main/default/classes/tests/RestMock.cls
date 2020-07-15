/**
* @author Florian Hoehn
* create mocks for rest callouts
**/
@isTest
public class RestMock implements HttpCalloutMock {
    /**
    * status code returned
    */
    protected Integer code;

    /**
    * status returned
    */
    protected String status;

    /**
    * body returned
    */
    protected String body;

    /**
    * response headers
    */
    protected Map<String, String> responseHeaders;

    /**
    * construct rest response mock
    * @param Integer code
    * @param String status
    * @param String body
    * @param Map<String, String> responseHeaders
    */
    public RestMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    /**
    * responds to callout inside test method
    * @param HttpRequest request
    * @return HttpResponse response
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            response.setHeader(key, this.responseHeaders.get(key));
        }
        response.setBody(this.body);
        response.setStatusCode(this.code);
        response.setStatus(this.status);
        return response;
    }
}