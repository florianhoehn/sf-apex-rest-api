/**
* @author Florian Hoehn
* defines the structure of the opportunity for the example integration
**/
public with sharing class ExampleOpportunityWrapper extends RestWrapper {
    /**
    * @description
    */
    public String opportunityId { get; set; }
    public String opportunityName { get; set; }
    public String opportunityStage { get; set; }
    public Integer opportunityAmount { get; set; }

    /**
    * constructor which leverages the parents constructor
    * @param Object obj
    */
    public ExampleOpportunityWrapper(Object obj) { super(obj); }

    /**
    * overrides mapFields method and defines the mapping sObject to wrapper
    * @param Object obj
    */
    private void mapFields(Object obj) {
        Opportunity opportunity = (Opportunity)obj;
        this.opportunityId = opportunity.Id;
        this.opportunityName = opportunity.Name;
        this.opportunityStage = opportunity.StageName;
        this.opportunityAmount = Integer.valueOf(opportunity.Amount);
    }
}