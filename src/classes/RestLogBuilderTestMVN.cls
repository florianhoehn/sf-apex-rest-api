/**
* RestLogBuilderTestMVN.cls
* Created By: Florian Hoehn
* Created On: January 16th, 2017
* Description: tests RestLogBuilderMvn
**/
@isTest
private class RestLogBuilderTestMVN {
    /**
    * @description tests successful log which does not get inserted as the log level is set to failure.
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_NotInserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestBody = 'expected request Body';
        String expectedResponseBody = 'expected request Body';

        Test.startTest();
            RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
            logBuilder.logLevel = RestLogBuilderMVN.LOG_LEVEL_FAILURE;
            Rest_Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertEquals(null, actualLog.Id); // NOT INSERTED AS LOG LEVEL IS FAILURE ONLY
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_MVN__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
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
            RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
            Rest_Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_MVN__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
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
            RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
            Rest_Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                                  .withRequestBody(expectedRequestBody)
                                                  .withResponseBody(expectedResponseBody)
                                                  .withErrorCode(expectedErrorCode)
                                                  .withException(expecedJsonEx)
                                                  .insertLog()
                                                  .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestBody, actualLog.Request_Body_MVN__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_MVN__c);
        System.assertEquals(expectedResponseBody, actualLog.Response_Body_MVN__c);
        System.assertEquals(expectedErrorCode, actualLog.Error_Code_MVN__c);
        System.assertEquals(expectedExceptionText, actualLog.Message_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_FAILURE, actualLog.Status_MVN__c);
    }
}