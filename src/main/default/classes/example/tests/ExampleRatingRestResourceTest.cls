/**
* @author Florian Hoehn
* tests ExampleRatingRestResource
**/
@isTest
private class ExampleRatingRestResourceTest {
    /**
    * setup test data for this class
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
    * tests get endpoint to get accounts with opportunities
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
        System.RestResponse res = new System.RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResource.getAccount();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapper actualResponse = (ExampleAccountWrapper)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapper.class);
        System.assertEquals(true, actualResponse.success);
        ExampleAccountWrapperTest.assertAccountMappings(expectedAccount, actualResponse);
        Rest_Log__c actuallog = [SELECT Id, Status__c FROM Rest_Log__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c);
    }

    /**
    * tests get endpoint to get accounts with opportunities failure
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
        System.RestResponse res = new System.RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResource.getAccount();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapper actualResponse = (ExampleAccountWrapper)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapper.class);
        System.assertEquals(false, actualResponse.success);
        Rest_Log__c actuallog = [SELECT Id, Status__c, Error_Code__c FROM Rest_Log__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals('GETACCOUNT', actualLog.Error_Code__c);
        System.assertEquals(RestLogBuilder.STATUS_FAILURE, actualLog.Status__c);
    }

    /**
    * tests put endpoint to update rating
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
        System.RestResponse res = new System.RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResource.updateRating();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapper actualResponse = (ExampleAccountWrapper)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapper.class);
        System.assertEquals(true, actualResponse.success);
        Rest_Log__c actuallog = [SELECT Id, Status__c FROM Rest_Log__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals(RestLogBuilder.STATUS_SUCCESS, actualLog.Status__c);
        Account actualAccount = [SELECT Rating
                                   FROM Account
                                  WHERE Id = :expectedAccount.Id];
        System.assertEquals(expectedRating, actualAccount.Rating);
    }

    /**
    * tests put endpoint to update rating failure
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
        System.RestResponse res = new System.RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ExampleRatingRestResource.updateRating();
        Test.stopTest();

        String actualJSONResponse = RestContext.response.responseBody.toString();
        ExampleAccountWrapper actualResponse = (ExampleAccountWrapper)System.JSON.deserialize(actualJSONResponse, ExampleAccountWrapper.class);
        System.assertEquals(false, actualResponse.success);
        Rest_Log__c actuallog = [SELECT Id, Status__c, Error_Code__c FROM Rest_Log__c];
        System.assertNotEquals(null, actualLog.Id);
        System.assertEquals('PUTACCOUNT', actualLog.Error_Code__c);
        System.assertEquals(RestLogBuilder.STATUS_FAILURE, actualLog.Status__c);
    }

}