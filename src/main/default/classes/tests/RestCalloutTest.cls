/**
* @author Florian Hoehn
* tests RestCallout
**/
@isTest
private class RestCalloutTest {
    /**
    * tests httpRequest is initiated on constructing the RestCallout class
    */
    @isTest private static void it_should_InstantiateWithDefaultHeaders() {
        Test.startTest();
            RestCallout actualRestCallout = new RestCallout();
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }

    /**
    * tests setting the method for the httpRequest
    */
    @isTest private static void it_should_SetTheMethod() {
        String expectedMethod = 'GET';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setMethod(expectedMethod);
        Test.stopTest();

        System.assertEquals(expectedMethod, actualRestCallout.httpRequest.getMethod());
    }

    /**
    * tests setting the endpoint for the httpRequest
    */
    @isTest private static void it_should_SetTheEndpoint() {
        String expectedEndpoint = 'endpoint';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setEndpoint(expectedEndpoint);
        Test.stopTest();

        System.assertEquals(expectedEndpoint, actualRestCallout.httpRequest.getEndpoint());
    }

    /**
    * tests setting the endpoint via named credential for the httpRequest
    */
    @isTest private static void it_should_SetTheEndpointViaNamedCredential() {
        String expectedEndpoint = 'endpoint';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setNamedCredential(expectedEndpoint);
        Test.stopTest();

        System.assertEquals('callout:' + expectedEndpoint, actualRestCallout.httpRequest.getEndpoint());
    }

    /**
    * tests setting the client certificate for the httpRequest
    */
    /* TODO: replace <certName> with an existing certificate in our org
    @isTest private static void it_should_SetTheClientCertificate() {
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
    @isTest private static void it_should_SetTheTimeOut() {
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setTimeout(1);
        Test.stopTest();

        // TODO: cannot assert timeout is set...
        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }

    /**
    * tests setting the header for the httpRequest
    */
    @isTest private static void it_should_SetAHeader() {
        String expectedHeaderName = 'headerName';
        String expectedHeaderValue = 'headerValue';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setHeader(expectedHeaderName, expectedHeaderValue);
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest.getHeader(expectedHeaderName));
        System.assertEquals(expectedHeaderValue, actualRestCallout.httpRequest.getHeader(expectedHeaderName));
    }

    /**
    * tests setting the body for the httpRequest
    */
    @isTest private static void it_should_SetTheBody() {
        String expectedBody = 'body';
        RestCallout actualRestCallout = new RestCallout();

        Test.startTest();
            actualRestCallout.setBody(expectedBody);
        Test.stopTest();

        System.assertEquals(expectedBody, actualRestCallout.httpRequest.getBody());
    }

    /**
    * tests making a successful callout
    */
    @isTest private static void it_should_DoACalloutWithReturnedSuccess() {
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

        System.assertEquals(expectedResponseBody, actualResponseBody);
    }

    /**
    * tests making a failed callout
    */
    @isTest private static void it_should_DoACalloutWithReturnedFailure() {
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

        System.assert(actualException.getMessage().contains(String.valueOf(expectedResponseStatus)));
        System.assert(actualException.getMessage().contains(expectedResponseBody));
    }
}