/**
* ExampleOpportunityWrapper.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: defines the structure of the opportunity for the example integration
**/
global with sharing class ExampleOpportunityWrapper extends RestWrapper {
    /**
    * @description
    */
    public String opportunityId { get; set; }
    public String opportunityName { get; set; }
    public String opportunityStage { get; set; }
    public Integer opportunityAmount { get; set; }

    /**
    * @description constructor which leverages the parents constructor
    * @param Object obj
    */
    public ExampleOpportunityWrapper(Object obj) { super(obj); }

    /**
    * @description overrides mapFields method and defines the mapping sObject to wrapper
    * @param Object obj
    */
    private void mapFields(Object obj) {
        Opportunity opportunity = (Opportunity)obj;
        this.opportunityId = Opportunity.Id;
        this.opportunityName = Opportunity.Name;
        this.opportunityStage = Opportunity.StageName;
        this.opportunityAmount = Integer.valueOf(Opportunity.Amount);
    }
}