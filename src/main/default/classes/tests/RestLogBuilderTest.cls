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
    private static void successLogRecordNotInserted() {
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

        System.assertEquals(null, actualLog.Id, 'Log is not set');
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c, 'Log Endpoint does not match');
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c, 'Log Request Body does not match');
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c, 'Log Response Body does not match');
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c, 'Log Status does not match');
    }

    /**
    * tests successful log which does get inserted
    */
    @isTest
    private static void successLogRecordInserted() {
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

        System.assertNotEquals(null, actualLog.Id, 'Log is not set');
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c, 'Log Endpoint does not match');
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c, 'Log Request Body does not match');
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c, 'Log Response Body does not match');
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c, 'Log Status does not match');
    }

    /**
    * tests failure log which gets inserted
    */
    @isTest
    private static void failureLogRecordInserted() {
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

        System.assertNotEquals(null, actualLog.Id, 'Log is not set');
        System.assertEquals(expectedEndpoint, actualLog.Endpoint__c, 'Log Endpoint does not match');
        System.assertEquals(expectedRequestBody, actualLog.Request_Body__c, 'Log Request Body does not match');
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c, 'Log Response Body does not match');
        System.assertEquals(expectedResponseBody, actualLog.Response_Body__c, 'Log Response Body does not match');
        System.assertEquals(expectedErrorCode, actualLog.Error_Code__c, 'Log Error Code does not match');
        System.assertEquals(expectedexceptionText, actualLog.Message__c, 'Log Message does not match');
        System.assertEquals(RestLogBuilder.STATUS_FAILURE, actualLog.Status__c, 'Log Status does not match');
    }
}