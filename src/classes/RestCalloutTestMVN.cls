/**
* RestCalloutTestMVN.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: Test class for RestCalloutMVN
**/
@isTest
private class RestCalloutTestMVN {
    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests httpRequest is initiated on constructing the RestCalloutMVN class
    */
    @isTest private static void it_should_InstantiateWithDefaultHeaders() {
        Test.startTest();
            RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        Test.stopTest();

        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the method for the httpRequest
    */
    @isTest private static void it_should_SetTheMethod() {
        String expectedMethod = 'GET';
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setMethod(expectedMethod);
        Test.stopTest();

        System.assertEquals(expectedMethod, actualRestCallout.httpRequest.getMethod());
    }

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the endpoint for the httpRequest
    */
    @isTest private static void it_should_SetTheEndpoint() {
        String expectedEndpoint = 'endpoint';
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setEndpoint(expectedEndpoint);
        Test.stopTest();

        System.assertEquals(expectedEndpoint, actualRestCallout.httpRequest.getEndpoint());
    }

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the endpoint via named credential for the httpRequest
    */
    @isTest private static void it_should_SetTheEndpointViaNamedCredential() {
        String expectedEndpoint = 'endpoint';
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setNamedCredential(expectedEndpoint);
        Test.stopTest();

        System.assertEquals('callout:' + expectedEndpoint, actualRestCallout.httpRequest.getEndpoint());
    }

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the client certificate for the httpRequest
    */
    /* TODO: replace <certName> with an existing certificate in our org
    @isTest private static void it_should_SetTheClientCertificate() {
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setClientCertificate('<certName>');
        Test.stopTest();

        // TODO: cannot assert certificate is set...
        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }*/

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the timeout for the httpRequest
    */
    @isTest private static void it_should_SetTheTimeOut() {
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setTimeout(1);
        Test.stopTest();

        // TODO: cannot assert timeout is set...
        System.assertNotEquals(null, actualRestCallout.httpRequest);
        System.assertEquals('application/json', actualRestCallout.httpRequest.getHeader('Content-Type'));
    }

    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests setting the body for the httpRequest
    */
    @isTest private static void it_should_SetTheBody() {
        String expectedBody = 'body';
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        
        Test.startTest();
            actualRestCallout.setBody(expectedBody);
        Test.stopTest();

        // TODO: cannot test timeout set...
        System.assertEquals(expectedBody, actualRestCallout.httpRequest.getBody());
    }
    
    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests making a successful callout
    */
    @isTest private static void it_should_DoACalloutWithReturnedSuccess() {
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        String expectedResponseBody = 'success body';
        RestResponseMockMVN responseMock = new RestResponseMockMVN(
            200,
            'SUCCESS',
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
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @description tests making a failed callout
    */
    @isTest private static void it_should_DoACalloutWithReturnedFailure() {
        RestCalloutMVN actualRestCallout = new RestCalloutMVN();
        Integer expectedResponseStatus = 400;
        String expectedResponseBody = 'failure body';
        RestResponseMockMVN responseMock = new RestResponseMockMVN(
            expectedResponseStatus,
            'FAILURE',
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