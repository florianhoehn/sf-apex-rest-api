/**
* @author Florian Hoehn
* tests RestCallout
**/
@isTest
private class RestCalloutTest {
    /**
    * tests httpRequest is initiated on constructing the RestCallout class
    */
    @isTest 
    private static void instantiateWithDefaultHeaders() {
        Test.startTest();
            RestCallout actualRestCallout = new RestCallout();
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest, 'Request is not set');
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'), 'Content Type does not match');
    }

    /**
    * tests setting the method for the httpRequest
    */
    @isTest 
    private static void setTheMethod() {
        String expectedMethod = 'GET';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setMethod(expectedMethod);
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest, 'Request is not set');
        System.assertEquals(expectedMethod, actualRestCallout.httpRequest.getMethod(), 'Method does not match');
    }

    /**
    * tests setting the endpoint for the httpRequest
    */
    @isTest
    private static void setTheEndpoint() {
        String expectedEndpoint = 'endpoint';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setEndpoint(expectedEndpoint);
        Test.stopTest();

        System.assertEquals(expectedEndpoint, actualRestCallout.httpRequest.getEndpoint(), 'Endpoint does not match');
    }

    /**
    * tests setting the endpoint via named credential for the httpRequest
    */
    @isTest
    private static void setTheEndpointViaNamedCredential() {
        String expectedEndpoint = 'endpoint';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setNamedCredential(expectedEndpoint);
        Test.stopTest();

        System.assertEquals('callout:' + expectedEndpoint, actualRestCallout.httpRequest.getEndpoint(), 'Endpoint does not match');
    }

    /**
    * tests setting the client certificate for the httpRequest
    */
    /* TODO: replace <certName> with an existing certificate in our org
    @isTest 
    private static void setTheClientCertificate() {
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setClientCertificate('<certName>');
        Test.stopTest();

        // TODO: cannot assert certificate is set...
        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }*/

    /**
    * tests setting the timeout for the httpRequest
    */
    @isTest
    private static void setTheTimeOut() {
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setTimeout(1);
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest, 'Request is not set');
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'), 'Content Type does not match');
    }

    /**
    * tests setting the header for the httpRequest
    */
    @isTest
    private static void setAHeader() {
        String expectedHeaderName = 'headerName';
        String expectedHeaderValue = 'headerValue';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setHeader(expectedHeaderName, expectedHeaderValue);
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest.getHeader(expectedHeaderName), 'Header is not set');
        System.assertEquals(expectedHeaderValue, actualRestCallout.httpRequest.getHeader(expectedHeaderName), 'Header does not match');
    }

    /**
    * tests setting the body for the httpRequest
    */
    @isTest
    private static void setTheBody() {
        String expectedBody = 'body';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setBody(expectedBody);
        Test.stopTest();

        System.assertEquals(expectedBody, actualRestCallout.httpRequest.getBody(), 'Body does not match');
    }

    /**
    * tests making a successful callout
    */
    @isTest
    private static void doACalloutWithReturnedSuccess() {
        RestCallout actualRestCallout = new RestCallout();
        String expectedResponseBody = 'success body';
        RestMock responseMock = new RestMock(
            200,
            RestLogBuilder.STATUS_SUCCESS,
            expectedResponseBody,
            new Map<String, String>()
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            String actualResponseBody = actualRestCallout.call();
        Test.stopTest();

        System.assertEquals(expectedResponseBody, actualResponseBody, 'Body does not match');
    }

    /**
    * tests making a failed callout
    */
    @isTest
    private static void doACalloutWithReturnedFailure() {
        RestCallout actualRestCallout = new RestCallout();
        Integer expectedResponseStatus = 400;
        String expectedResponseBody = 'failure body';
        RestMock responseMock = new RestMock(
            expectedResponseStatus,
            RestLogBuilder.STATUS_FAILURE,
            expectedResponseBody,
            new Map<String, String>()
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            Exception actualException;
            try {
                actualRestCallout.call();
            } catch (CalloutException e) {
                actualException = e;
            }

        Test.stopTest();

        System.assert(actualException.getMessage().contains(String.valueOf(expectedResponseStatus)), 'Response Statis does not match');
        System.assert(actualException.getMessage().contains(expectedResponseBody), 'Response Message does not match');
    }
}