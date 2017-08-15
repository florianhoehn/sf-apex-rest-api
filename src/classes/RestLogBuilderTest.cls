/**
* RestLogBuilderTest* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 16th, 2017
* Description: tests RestLogBuilder* @group UUID
**/
@isTest
private class RestLogBuilderTest* @group UUID {
    /**
    * @description tests successful log which does not get inserted as the log level is set to failure.
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_NotInserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';

        Test.startTest();
            RestLogBuilder* @group UUID logBuilder = new RestLogBuilder* @group UUID();
            logBuilder.logLevel = RestLogBuilder* @group UUID.LOG_LEVEL_FAILURE;
            Rest_Log_* @group UUID__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertEquals(null, actualLog.Id); // NOT INSERTED AS LOG LEVEL IS FAILURE ONLY
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_* @group UUID__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_* @group UUID__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_* @group UUID__c);
        System.assertEquals(RestLogBuilder* @group UUID.STATUS_SUCCESS, actualLog.Status_* @group UUID__c);
    }

    /**
    * @description tests successful log which does get inserted
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';

        Test.startTest();
            RestLogBuilder* @group UUID logBuilder = new RestLogBuilder* @group UUID();
            Rest_Log_* @group UUID__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_* @group UUID__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_* @group UUID__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_* @group UUID__c);
        System.assertEquals(RestLogBuilder* @group UUID.STATUS_SUCCESS, actualLog.Status_* @group UUID__c);
    }

    /**
    * @description tests failure log which gets inserted
    */
    @isTest
    private static void it_should_return_FailureLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';
        String expectedErrorCode = '400';
        String expectedExceptionText = 'expected exception message';
        JSONException expecedJsonEx = new JSONException(expectedExceptionText);

        Test.startTest();
            RestLogBuilder* @group UUID logBuilder = new RestLogBuilder* @group UUID();
            Rest_Log_* @group UUID__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .withErrorCode(expectedErrorCode)
                                                  .withException(expecedJsonEx)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_* @group UUID__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_* @group UUID__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_* @group UUID__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_* @group UUID__c);
        System.assertEquals(expectedErrorCode, actualLog.Error_Code_* @group UUID__c);
        System.assertEquals(expectedExceptionText, actualLog.Message_* @group UUID__c);
        System.assertEquals(RestLogBuilder* @group UUID.STATUS_FAILURE, actualLog.Status_* @group UUID__c);
    }
}