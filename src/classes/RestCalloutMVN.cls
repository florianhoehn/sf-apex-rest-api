/**
* RestCalloutMVN.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: defines the core functionality of callouts - should be extended for each specific callout
**/
public with sharing virtual class RestCalloutMVN {
    /**
    * @description defines max timeout
    */
    @TestVisible private Integer MAX_TIMEOUT = 120000;

    /**
    * @description defines httpRequest for the callout
    */
    @TestVisible protected HttpRequest httpRequest;
    
    /**
    * @description constructor, initiates httpRequest and number of tries
    */
    public RestCalloutMVN() {
        this.createHttpRequest();
    }

    /**
    * @description sets method
    * @date January 17th, 2017
    * @param String method
    */
    @TestVisible protected void setMethod(String method) {
        this.httpRequest.setMethod(method);
    }

    /**
    * @description sets endpoint
    * @date January 17th, 2017
    * @param String endpoint
    */
    @TestVisible protected void setEndpoint(String endpoint) {
        this.httpRequest.setEndpoint(endpoint);
    }

    /**
    * @description sets endpoint
    * @date January 17th, 2017
    * @param String namedCredential
    */
    @TestVisible protected void setNamedCredential(String namedCredential) {
        this.httpRequest.setEndpoint('callout:' + namedCredential);
    }

    /**
    * @description sets client certificate
    * @date January 17th, 2017
    * @param String certificateName
    */
    @TestVisible protected void setClientCertificate(String certificateName) {
        this.httpRequest.setClientCertificateName(certificateName);
    }

    /**
    * @description sets timeout
    * @date January 17th, 2017
    * @param Integer timeout
    */
    @TestVisible protected void setTimeout(Integer timeout) {
        this.httpRequest.setTimeout(timeout);
    }

    /**
    * @description sets JSON body
    * @date January 17th, 2017
    * @param String requestBody
    */
    @TestVisible protected void setBody(String requestBody) {
        this.httpRequest.setBody(requestBody);
    }

    /**
    * @description do the actual callout
    * @date January 17th, 2017
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
    * @description initialises the httpRequest with all default headers
    * @date January 17th, 2017
    * we can move anything that is the same for all callouts in here i.e. endpoint, method, certificate, timeout, content-type
    */
    protected void createHttpRequest() {
        this.httpRequest = new HttpRequest();
        this.httpRequest.setTimeout(MAX_TIMEOUT);
        this.httpRequest.setHeader('Content-Type', 'application/json');
    }
}