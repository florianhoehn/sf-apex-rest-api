/**
* RestMockMVN.cls
* Created By: Florian Hoehn
* Created On: * January 17th, 2017
* Description: create mocks for rest callouts
**/
@isTest
public class RestMockMVN implements HttpCalloutMock {
    /**
    * @description status code returned 
    */
    protected Integer code;
    
    /**
    * @description status returned 
    */
    protected String status;
    
    /**
    * @description body returned 
    */
    protected String body;
    
    /**
    * @description response headers 
    */
    protected Map<String, String> responseHeaders;

    /**
    * @description construct rest response mock
    * @param Integer code
    * @param String status
    * @param String body
    * @param Map<String, String> responseHeaders
    */
    public RestMockMVN(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    /**
    * @description responds to callout inside test method
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