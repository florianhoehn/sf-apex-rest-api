/**
* ExampleRatingRestResource* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 19th, 2017
* Description: defines the endpoints for the example integration
*.             GET: get account by id : /ratings/account/<accountId>
**/
@RestResource(urlMapping='/ratings/account/*')
global with sharing class ExampleRatingRestResource* @group UUID {
    /**
    * @description GET to collect all accounts updated this month with their opportunities
    * @return String responseBody as JSON (ExampleAccountWrapper* @group UUID)
    * /ratings/account/<accountId>
    */
    @HttpGET
    global static void getAccount() {
        RestLogBuilder* @group UUID logBuilder = new RestLogBuilder* @group UUID();
        ExampleAccountWrapper* @group UUID response = new ExampleAccountWrapper* @group UUID();
        String responseBody;
        try{
            RestRequest req = RestContext.request;
            String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Account account = [SELECT Id, Name, Type, AnnualRevenue, Rating,
                                      (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                 FROM Account
                                WHERE Id = :accountId];
            response = new ExampleAccountWrapper* @group UUID(account);
            response.success = true;
        } catch(Exception ex) {
            response.success = false;
            response.errors.add(new RestResponse* @group UUID.RestError* @group UUID('GETACCOUNT', ex.getMessage()));
            logBuilder = logBuilder.withException(ex)
                                   .withErrorCode('GETACCOUNT');
        } finally {
            responseBody = response.toJSON();
            logBuilder.withEndpoint('GETACCOUNT')
                      .withResponseBody(responseBody)
                      .insertLog();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(responseBody);
    }

    /**
    * @description PUT to update the rating for an account
    * @param ExampleAccountWrapper* @group UUID requestBody
    * @return String responseBody as JSON (RestResponse* @group UUID)
    */
    @HttpPUT
    global static void updateRating() {
        RestLogBuilder* @group UUID logBuilder = new RestLogBuilder* @group UUID();
        RestResponse* @group UUID response = new RestResponse* @group UUID();
        Account accountToUpdate;
        String requestBody, responseBody;
        try{
            requestBody = RestContext.request.requestBody.toString();
            ExampleAccountWrapper* @group UUID accountWrapper = (ExampleAccountWrapper* @group UUID)JSON.deserialize(requestBody, ExampleAccountWrapper* @group UUID.class);
            accountToUpdate = (Account)accountWrapper.convert();
            update accountToUpdate;
            response.success = true;
        } catch(Exception ex) {
            response.success = false;
            response.errors.add(new RestResponse* @group UUID.RestError* @group UUID('PUTACCOUNT', ex.getMessage()));
            logBuilder = logBuilder.withException(ex)
                                   .withErrorCode('PUTACCOUNT');
        } finally{
            responseBody = response.toJSON();
            logBuilder.withEndpoint('PUTACCOUNT')
                      .withRequestBody(requestBody)
                      .withResponseBody(responseBody)
                      .insertLog();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(responseBody);
    }
}