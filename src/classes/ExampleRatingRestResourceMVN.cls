/**
* ExampleRatingRestResourceMVN.cls
* Created By: Florian Hoehn
* Created On: January 19th, 2017
* Description: defines the endpoints for the example integration
*.             GET: get account by id : /ratings/account/<accountId>
**/
@RestResource(urlMapping='/ratings/account/*')
global with sharing class ExampleRatingRestResourceMVN {
    /**
    * @description GET to collect all accounts updated this month with their opportunities
    * @return String responsePayload as JSON (ExampleAccountWrapperMVN)
    * /ratings/account/<accountId>
    */
    @HttpGET
    global static void getAccount() {
        RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
        ExampleAccountWrapperMVN response = new ExampleAccountWrapperMVN();
        String responsePayload;
        try{
            RestRequest req = RestContext.request;
            String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Account account = [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                      (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                 FROM Account
                                WHERE Id = :accountId];
            response = new ExampleAccountWrapperMVN(account);
            response.success = true;
        } catch(Exception ex) {
            response.success = false;
            response.errors.add(new RestResponseMVN.RestErrorMVN('GETACCOUNT', ex.getMessage()));
            logBuilder = logBuilder.withException(ex)
                                   .withErrorCode('GETACCOUNT');
        } finally {
            responsePayload = response.toJSON();
            logBuilder.withEndpoint('GETACCOUNT')
                      .withResponsePayload(responsePayload)
                      .insertLog();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(responsePayload);
    }

    /**
    * @description PUT to update the rating for an account
    * @param ExampleAccountWrapperMVN requestPayload
    * @return String responsePayload as JSON (RestResponseMVN)
    */
    @HttpPUT
    global static void updateRating() {
        RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
        RestResponseMVN response = new RestResponseMVN();
        Account accountToUpdate;
        String requestPayload, responsePayload;
        try{
            requestPayload = RestContext.request.requestBody.toString();
            ExampleAccountWrapperMVN accountWrapper = (ExampleAccountWrapperMVN)JSON.deserialize(requestPayload, ExampleAccountWrapperMVN.class);
            accountToUpdate = (Account)accountWrapper.convert();
            update accountToUpdate;
            response.success = true;
        } catch(Exception ex) {
            response.success = false;
            response.errors.add(new RestResponseMVN.RestErrorMVN('PUTACCOUNT', ex.getMessage()));
            logBuilder = logBuilder.withException(ex)
                                   .withErrorCode('PUTACCOUNT');
        } finally{
            responsePayload = response.toJSON();
            logBuilder.withEndpoint('PUTACCOUNT')
                      .withRequestPayload(requestPayload)
                      .withResponsePayload(responsePayload)
                      .insertLog();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(responsePayload);
    }
}