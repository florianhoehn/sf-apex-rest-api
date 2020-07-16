/**
* @author Florian Hoehn
* tests RestLogBuilder
**/
@isTest
private class RestLogBuilderTest {
    /**
    * tests successful log which does not get inserted as the log level is set to failure.
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_NotInserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';

        Test.startTest();
            RestLogBuilder logBuilder = new RestLogBuilder();
            logBuilder.logLevel = RestLogBuilder.LOG_LEVEL_FAILURE;
            Rest_Log__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertEquals(null, actualLog.Id); // NOT INSERTED AS LOG LEVEL IS FAILURE ONLY
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c);
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c);
    }

    /**
    * tests successful log which does get inserted
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';

        Test.startTest();
            RestLogBuilder logBuilder = new RestLogBuilder();
            Rest_Log__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c);
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c);
    }

    /**
    * tests failure log which gets inserted
    */
    @isTest
    private static void it_should_return_FailureLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';
        String expectedErrorCode = '400';
        String expectedexceptionText = 'expected exception message';
        JSONException expecedJsonEx = new JSONException(expectedexceptionText);

        Test.startTest();
            RestLogBuilder logBuilder = new RestLogBuilder();
            Rest_Log__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .withErrorCode(expectedErrorCode)
                                                  .withException(expecedJsonEx)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c);
        System.assertEquals(expectedErrorCode, actualLog.Error_Code__c);
        System.assertEquals(expectedexceptionText, actualLog.Message__c);
        System.assertEquals(RestLogBuilder.STATUS_FAILURE, actualLog.Status__c);
    }
}