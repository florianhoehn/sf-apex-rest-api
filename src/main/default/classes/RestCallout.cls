/**
* @author Florian Hoehn
* defines the core functionality of callouts - should be extended for each specific callout
**/
public with sharing virtual class RestCallout {
    /**
    * defines max timeout
    */
    @TestVisible private Integer maxTimeout = 120000;

    /**
    * defines httpRequest for the callout
    */
    @TestVisible protected HttpRequest httpRequest;

    /**
    * constructor, initiates httpRequest and number of tries
    */
    public RestCallout() {
        this.createHttpRequest();
    }

    /**
    * sets method
    * @param String method
    */
    @TestVisible protected void setMethod(String method) {
        this.httpRequest.setMethod(method);
    }

    /**
    * sets endpoint
    * @param String endpoint
    */
    @TestVisible protected void setEndpoint(String endpoint) {
        this.httpRequest.setEndpoint(endpoint);
    }

    /**
    * sets endpoint
    * @param String namedCredential
    */
    @TestVisible protected void setNamedCredential(String namedCredential) {
        this.httpRequest.setEndpoint('callout:' + namedCredential);
    }

    /**
    * sets client certificate
    * @param String certificateName
    */
    @TestVisible protected void setClientCertificate(String certificateName) {
        this.httpRequest.setClientCertificateName(certificateName);
    }

    /**
    * sets timeout
    * @param Integer timeout
    */
    @TestVisible protected void setTimeout(Integer timeout) {
        this.httpRequest.setTimeout(timeout);
    }

    /**
    * set header
    * @param String headerName
    * @param String headerValue
    */
    @TestVisible protected void setHeader(String headerName, String headerValue) {
        this.httpRequest.setHeader(headerName, headerValue);
    }


    /**
    * sets JSON body
    * @param String requestBody
    */
    @TestVisible protected void setBody(String requestBody) {
        this.httpRequest.setBody(requestBody);
    }

    /**
    * do the actual callout
    * @return String requestBody
    */
    @TestVisible protected String call() {
        Http http = new Http();
        HttpResponse httpResponse = http.send(this.httpRequest);
        if(httpResponse.getStatusCode() != 200) {
            throw new System.CalloutException('Status Code: ' + httpResponse.getStatusCode() + ' : ' + httpResponse.getBody());
        }
        return httpResponse.getBody();
    }

    /**
    * initialises the httpRequest with all default headers
    * we can move anything that is the same for all callouts in here i.e. endpoint, method, certificate, timeout, content-type
    */
    protected void createHttpRequest() {
        this.httpRequest = new HttpRequest();
        this.httpRequest.setTimeout(maxTimeout);
        this.httpRequest.setHeader('Content-Type', 'application/json');
    }
}