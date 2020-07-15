/**
* @author Florian Hoehn
* defines the specific callout for the example integration to receive rating information
* defines calls for this callout from the process builder, batch jobs and an @future call
**/
public with sharing class ExampleRatingCallout extends RestCallout {
    @TestVisible
    private static String exceptionText = 'Example Standard Error Message';
    /**
    * holds the account record which the callout is made from
    */
    private Account account;

    /**
    * constructor
    * @param Account account
    */
    public ExampleRatingCallout(Account account) {
        this.account = account;
    }

    /**
    * send the account with opportunities to rating engine
    */
    public void sendAccountToRatingEngine() {
        RestLogBuilder logBuilder = new RestLogBuilder();
        String requestBody, responseBody, errorCode;
        try {
            ExampleAccountWrapper wrapper = new ExampleAccountWrapper(this.account);
            this.setMethod('POST');
            this.setEndpoint('/rating/engine');
            requestBody = wrapper.toJSON();
            this.setBody(requestBody);
            responseBody = this.call();
            wrapper = (ExampleAccountWrapper)System.JSON.deserialize(responseBody, ExampleAccountWrapper.class);
            if(wrapper.success) {
                this.account = (Account)wrapper.convert();
                update this.account;
            } else {
                if(wrapper.errors != null && !wrapper.errors.isEmpty()) { // throw first error returned
                    errorCode = wrapper.errors.get(0).errorCode;
                    throw new System.CalloutException(wrapper.errors.get(0).message);
                } else {
                    errorCode = exceptionText;
                    throw new System.CalloutException(exceptionText);
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
    * callout batch accounts called by @future and batch
    * @param Set<Id> accountIds
    */
    public static void sendBatchOfAccounts(Set<Id> accountIds) {
        for(Account account : [SELECT Id, Name, Type, AnnualRevenue, Rating,
                                      (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                 FROM Account
                                WHERE Id IN :accountIds]) {
            ExampleRatingCallout callout = new ExampleRatingCallout(account);
            callout.sendAccountToRatingEngine();
        }
    }

    /**
    * method that can be called by a process builder - schedules future calls to do the example callout
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
    * future method to do the actual callout
    * @param Set<Id> accountIds
    */
    @future(callout=true)
    public static void futureSendAccounts(Set<Id> accountIds) {
        sendBatchOfAccounts(accountIds);
    }
}