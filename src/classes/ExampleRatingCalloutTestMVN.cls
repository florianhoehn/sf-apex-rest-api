/**
* ExampleRatingCalloutTestMVN.cls
* Created By: Florian Hoehn
* Created On: January 18th, 2017
* Description: Test class for ExampleRatingCalloutMVN
**/
@isTest
private class ExampleRatingCalloutTestMVN {
    private static String expectedResponseBodySuccess = '{"success":true,"errors":[],"accountId":"{0}","accountRating":"{1}"}';
    private static String expectedResponseBodyFailureNoErrorDefined = '{"success":false,"errors":[]}';
    private static String expectedResponseBodyFailure = '{"success":false,"errors":[{"errorCode":"{0}","message":"{1}"}]}';
    
    /**
    * @description setup test data for this class
    */
    @testSetup
    private static void setupTestData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Test Type',
            AnnualRevenue = 500000
        );
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Name = 'Test Opportunity',
            StageName = 'Test StageName',
            Amount = 100000,
            CloseDate = System.today() + 1
        );
        insert testOpportunity;
    }

    /**
    * @description tests making a successful callout 
    */
    @isTest private static void it_should_DoACalloutWithReturnedRating() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        String expectedRating = 'Test Account Rating';
        expectedResponseBodySuccess = expectedResponseBodySuccess.replace('{0}', expectedAccount.Id);
        expectedResponseBodySuccess = expectedResponseBodySuccess.replace('{1}', expectedRating);
        RestMockMVN responseMock = new RestMockMVN(
            200,
            'SUCCESS',
            expectedResponseBodySuccess,
            new Map<String, String> {'Content-Type' => 'application/json'}
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            ExampleRatingCalloutMVN actualRestCallout = new ExampleRatingCalloutMVN(expectedAccount);
            actualRestCallout.sendAccountToRatingEngine();
        Test.stopTest();

        Account actualAccount = [SELECT Id, Rating FROM Account WHERE Id = :expectedAccount.Id];
        System.assertEquals(expectedRating, actualAccount.Rating);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
    }

    /**
    * @description tests making a successful callout via the invoker (process builder)
    */
    @isTest private static void it_should_DoACalloutByInvokerWithReturnedRating() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        String expectedRating = 'Test Account Rating';
        expectedResponseBodySuccess = expectedResponseBodySuccess.replace('{0}', expectedAccount.Id);
        expectedResponseBodySuccess = expectedResponseBodySuccess.replace('{1}', expectedRating);
        RestMockMVN responseMock = new RestMockMVN(
            200,
            RestLogBuilderMVN.STATUS_SUCCESS,
            expectedResponseBodySuccess,
            new Map<String, String> {'Content-Type' => 'application/json'}
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            ExampleRatingCalloutMVN.sendAccountsToRatingEngine(new List<Id> {expectedAccount.Id});
        Test.stopTest();

        Account actualAccount = [SELECT Id, Rating FROM Account WHERE Id = :expectedAccount.Id];
        System.assertEquals(expectedRating, actualAccount.Rating);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
    }

    /**
    * @description tests making a failed callout
    */
    @isTest private static void it_should_DoACalloutWithErrorReturned() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        String expectedErrorCode = 'Test Code';
        String expectedMessage = 'Test Message';
        expectedResponseBodyFailure = expectedResponseBodyFailure.replace('{0}', expectedErrorCode);
        expectedResponseBodyFailure = expectedResponseBodyFailure.replace('{1}', expectedMessage);
        RestMockMVN responseMock = new RestMockMVN(
            200,
            RestLogBuilderMVN.STATUS_FAILURE,
            expectedResponseBodyFailure,
            new Map<String, String> {'Content-Type' => 'application/json'}
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            ExampleRatingCalloutMVN actualRestCallout = new ExampleRatingCalloutMVN(expectedAccount);
            actualRestCallout.sendAccountToRatingEngine();
        Test.stopTest();

        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c, Error_Code_MVN__c, Message_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(expectedErrorCode, actualLog.Error_Code_MVN__c);
        System.assertEquals(expectedMessage, actualLog.Message_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_FAILURE, actualLog.Status_MVN__c);
    }

    /**
    * @description tests making a failed callout without error message being sent by endpoint
    */
    @isTest private static void it_should_DoACalloutWithStandardErrorReturned() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        RestMockMVN responseMock = new RestMockMVN(
            200,
            RestLogBuilderMVN.STATUS_FAILURE,
            expectedResponseBodyFailureNoErrorDefined,
            new Map<String, String> {'Content-Type' => 'application/json'}
        );
        Test.setMock(HttpCalloutMock.class, responseMock);

        Test.startTest();
            ExampleRatingCalloutMVN actualRestCallout = new ExampleRatingCalloutMVN(expectedAccount);
            actualRestCallout.sendAccountToRatingEngine();
        Test.stopTest();

        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c, Error_Code_MVN__c, Message_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(ExampleRatingCalloutMVN.EXCEPTION_TEXT, actualLog.Error_Code_MVN__c);
        System.assertEquals(ExampleRatingCalloutMVN.EXCEPTION_TEXT, actualLog.Message_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_FAILURE, actualLog.Status_MVN__c);
    }
}