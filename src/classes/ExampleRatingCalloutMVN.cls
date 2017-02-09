/**
* ExampleRatingCalloutMVN.cls
* Created By: Florian Hoehn
* Created On: January 18th, 2017
* Description: defines the specific callout for the example integration to receive rating information
*              defines calls for this callout from the process builder, batch jobs and an @future call
**/
public with sharing class ExampleRatingCalloutMVN extends RestCalloutMVN {
    @TestVisible private static String EXCEPTION_TEXT = 'Example Standard Error Message'; 
    /**
    * @description holds the account record which the callout is made from
    */
    private Account account;

    /**
    * @description constructor
    * @param Account account
    */
    public ExampleRatingCalloutMVN(Account account) {
        this.account = account;
    }

    /**
    * @description send the account with opportunities to rating engine
    */
    public void sendAccountToRatingEngine() {
        RestLogBuilderMVN logBuilder = new RestLogBuilderMVN();
        String requestBody, responseBody, errorCode;
        try {
            ExampleAccountWrapperMVN wrapper = new ExampleAccountWrapperMVN(this.account);
            this.setMethod('POST');
            this.setEndpoint('/rating/engine');
            requestBody = wrapper.toJSON();
            this.setBody(requestBody);
            responseBody = this.call();
            wrapper = (ExampleAccountWrapperMVN)System.JSON.deserialize(responseBody, ExampleAccountWrapperMVN.class);
            if(wrapper.success) {
                this.account = (Account)wrapper.convert();
                update this.account;
            } else {
                if(wrapper.errors != null && !wrapper.errors.isEmpty()) { // throw first error returned
                    errorCode = wrapper.errors.get(0).errorCode;
                    throw new System.CalloutException(wrapper.errors.get(0).message); 
                } else {
                    errorCode = EXCEPTION_TEXT;
                    throw new System.CalloutException(EXCEPTION_TEXT); 
                }
            }
        } catch(Exception e) {
            logBuilder = logBuilder.withException(e)
                                   .withErrorCode(errorCode);
        } finally {
            logBuilder.withEndpoint('ePlan')
                      .withRequestBody(requestBody)
                      .withResponseBody(responseBody)
                      .insertLog();
        }
    }

    /**
    * @description callout batch accounts called by @future and batch
    * @param Set<Id> accountIds
    */
    public static void sendBatchOfAccounts(Set<Id> accountIds) {
        for(Account account : [SELECT Id, Name, Type, AnnualRevenue, Rating, 
                                      (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                 FROM Account 
                                WHERE Id IN :accountIds]) {
            ExampleRatingCalloutMVN callout = new ExampleRatingCalloutMVN(account);
            callout.sendAccountToRatingEngine();
        }
    }

    /**
    * @description method that can be called by a process builder - schedules future calls to do the example callout
    *              splits the list into chunks of 100 to circumvent governer limits (turn the process off for data migrations)
    * @param List<Id> accountIds
    */
    @InvocableMethod
    public static void sendAccountsToRatingEngine(List<Id> accountIds) {
        for(Integer chunkCounter = 0; chunkCounter <= accountIds.size()/100; chunkCounter++) {
            Set<Id> accountIdsToSend = new Set<Id>();
            Integer upperBound = (((chunkCounter*100)+100) > accountIds.size()) ? accountIds.size() : ((chunkCounter*100)+100);
            for(Integer counter = (chunkCounter*100); counter < upperBound; counter++) {
                accountIdsToSend.add(accountIds.get(counter));
            }
            futureSendAccounts(accountIdsToSend);
        }
    }

    /**
    * @description future method to do the actual callout
    * @param Set<Id> accountIds
    */
    @future(callout=true)
    public static void futureSendAccounts(Set<Id> accountIds) {
        sendBatchOfAccounts(accountIds);
    }
}