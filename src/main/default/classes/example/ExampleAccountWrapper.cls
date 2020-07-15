/**
* ExampleAccountWrapper.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: defines the structure of the account for the example integration
**/
public with sharing class ExampleAccountWrapper extends RestResponse {
    /**
    * @description
    */
    @TestVisible private final static Integer BIGPLAYERLINE = 100000;

    /**
    * @description
    */
    public String accountId { get; set; }
    public String accountName { get; set; }
    public String accountType { get; set; }
    public String accountRating { get; set; }
    public Boolean isBigPlayer { get; set; }
    public List<ExampleOpportunityWrapper> opportunities { get; set; }

    /**
    * @description constructor
    */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    public ExampleAccountWrapper() {}

    /**
    * @description constructor which leverages the parents constructor
    * @param Object obj
    */
    public ExampleAccountWrapper(Object obj) { super(obj); }

    /**
    * @description overrides mapFields method and defines the mapping sObject to wrapper
    * @param Object obj
    */
    private void mapFields(Object obj) {
        Account account = (Account)obj;
        this.accountId = account.Id;
        this.accountName = account.Name;
        this.accountType = account.Type;
        this.isBigPlayer = account.AnnualRevenue > BIGPLAYERLINE;
        this.opportunities = new List<ExampleOpportunityWrapper>();
        for(Opportunity opportunity : account.Opportunities) {
            this.opportunities.add(new ExampleOpportunityWrapper(opportunity));
        }
    }

    /**
    * @description overrides mapFields method and defines the mapping wrapper to sObject
    * @param Object obj
    */
    private Object convertFields() {
        Account account = [SELECT Id, Rating FROM Account WHERE Id = :accountId];
        account.Rating = this.accountRating;
        return account;
    }
}