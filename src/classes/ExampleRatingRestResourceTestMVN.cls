/**
* ExampleRatingRestResourceTestMVN.cls
* Created By: Florian Hoehn
* Created On: January 19th, 2017
* Description: tests ExampleRatingRestResourceMVN
**/
@isTest
private class ExampleRatingRestResourceTestMVN {
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
    * @description tests get endpoint to get accounts with opportunities
    */
    @isTest
    private static void it_should_GetAccountWithOpportunitiesSuccess() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ratings/account/' + expectedAccount.Id;
        req.httpMethod = 'GET';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResourceMVN.getAccount();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapperMVN actualResponse = (ExampleAccountWrapperMVN)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapperMVN.class);
        System.assertEquals(true, actualResponse.success);
        ExampleAccountWrapperTestMVN.assertAccountMappings(expectedAccount, actualResponse);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
    }

    /**
    * @description tests get endpoint to get accounts with opportunities failure
    */
    @isTest
    private static void it_should_GetAccountFailure() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ratings/account/' + expectedAccount.Id + 'FAIL';
        req.httpMethod = 'GET';
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResourceMVN.getAccount();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapperMVN actualResponse = (ExampleAccountWrapperMVN)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapperMVN.class);
        System.assertEquals(false, actualResponse.success);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c, Error_Code_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals('GETACCOUNT', actualLog.Error_Code_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_FAILURE, actualLog.Status_MVN__c);
    }

    /**
    * @description tests put endpoint to update rating
    */
    @isTest
    private static void it_should_UpdateRating() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        String expectedRating = 'Test Rating';
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ratings/account/' + expectedAccount.Id;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{"accountId":"' + expectedAccount.Id + '","accountRating":"' + expectedRating + '"}');
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResourceMVN.updateRating();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapperMVN actualResponse = (ExampleAccountWrapperMVN)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapperMVN.class);
        System.assertEquals(true, actualResponse.success);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilderMVN.STATUS_SUCCESS, actualLog.Status_MVN__c);
        Account actualAccount = [SELECT Rating
                                   FROM Account
                                  WHERE Id = :expectedAccount.Id];
        System.assertEquals(expectedRating, actualAccount.Rating);
    }

    /**
    * @description tests put endpoint to update rating failure
    */
    @isTest
    private static void it_should_UpdateRatingFailure() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];
        String expectedRating = 'Test Rating';
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ratings/account/' + expectedAccount.Id;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{"accountId":"' + expectedAccount.Id + 'FAIL","accountRating":"' + expectedRating + '"}');
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResourceMVN.updateRating();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapperMVN actualResponse = (ExampleAccountWrapperMVN)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapperMVN.class);
        System.assertEquals(false, actualResponse.success);
        Rest_Log_MVN__c actuallog = [SELECT Id, Status_MVN__c, Error_Code_MVN__c FROM Rest_Log_MVN__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals('PUTACCOUNT', actualLog.Error_Code_MVN__c);
        System.assertEquals(RestLogBuilderMVN.STATUS_FAILURE, actualLog.Status_MVN__c);
    }

}