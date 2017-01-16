/**
* @author Florian Hoehn
* @date 08/12/2016
* @group ￼integration
* @description ￼some description here
*/
@isTest
private class LogBuilderTestMVN {
    /**
    * @author Florian Hoehn
    * @date 08/12/2016
    * @description tests successful log which does not get inserted as the log level is set to failure.
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_NotInserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestPayload = 'expected request payload';
        String expectedResponsePayload = 'expected request payload';

        Test.startTest();
            LogBuilderMVN logBuilder = new LogBuilderMVN();
            logBuilder.logLevel = logBuilder.LOGLEVEL_FAILURE;
            Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                             .withRequestPayload(expectedRequestPayload)
                                             .withResponsePayload(expectedResponsePayload)
                                             .insertLog()
                                             .build();
        Test.stopTest();

        System.assertEquals(null, actualLog.Id); // NOT INSERTED AS LOG LEVEL IS FAILURE ONLY
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestPayload, actualLog.Request_Payload_MVN__c);
        System.assertEquals(expectedResponsePayload, actualLog.Response_Payload_MVN__c);
        System.assertEquals(logBuilder.SUCCESS, actualLog.Status_MVN__c);
    }
    
    /**
    * @author Florian Hoehn
    * @date 08/12/2016
    * @description tests successful log which does get inserted
    */
    @isTest
    private static void it_should_return_SuccessLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestPayload = 'expected request payload';
        String expectedResponsePayload = 'expected request payload';

        Test.startTest();
            LogBuilderMVN logBuilder = new LogBuilderMVN();
            Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                             .withRequestPayload(expectedRequestPayload)
                                             .withResponsePayload(expectedResponsePayload)
                                             .insertLog()
                                             .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestPayload, actualLog.Request_Payload_MVN__c);
        System.assertEquals(expectedResponsePayload, actualLog.Response_Payload_MVN__c);
        System.assertEquals(logBuilder.SUCCESS, actualLog.Status_MVN__c);
    }
    
    /**
    * @author Florian Hoehn
    * @date 08/12/2016
    * @description tests failure log which gets inserted
    */
    @isTest
    private static void it_should_return_FailureLogRecord_Inserted() {
        String expectedEndpoint = 'expectedEndpoint';
        String expectedRequestPayload = 'expected request payload';
        String expectedResponsePayload = 'expected request payload';
        String expectedErrorCode = '400';
        String expectedExceptionText = 'expected exception message';
        JSONException expecedJsonEx = new JSONException(expectedExceptionText);

        Test.startTest();
            LogBuilderMVN logBuilder = new LogBuilderMVN();
            Log_MVN__c actualLog = logBuilder.withEndpoint(expectedEndpoint)
                                             .withRequestPayload(expectedRequestPayload)
                                             .withResponsePayload(expectedResponsePayload)
                                             .withErrorCode(expectedErrorCode)
                                             .withException(expecedJsonEx)
                                             .insertLog()
                                             .build();
        Test.stopTest();

        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedEndpoint, actualLog.Endpoint_MVN__c);
        System.assertEquals(expectedRequestPayload, actualLog.Request_Payload_MVN__c);
        System.assertEquals(expectedResponsePayload, actualLog.Response_Payload_MVN__c);
        System.assertEquals(expectedResponsePayload, actualLog.Response_Payload_MVN__c);
        System.assertEquals(expectedErrorCode, actualLog.Error_Code_MVN__c);
        System.assertEquals(expectedExceptionText, actualLog.Message_MVN__c);
        System.assertEquals(logBuilder.FAILURE, actualLog.Status_MVN__c);
    }
}