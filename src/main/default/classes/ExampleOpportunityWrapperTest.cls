/**
* ExampleOpportunityWrapperTest.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: tests ExampleOpportunityWrapper
**/
@isTest
public class ExampleOpportunityWrapperTest {
    /**
    * @description setup test data for this class
    */
    @testSetup
    private static void setupTestData() {
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Test StageName',
            Amount = 100000,
            CloseDate = System.today() + 1
        );
        insert testOpportunity;
    }

    /**
    * @description tests opportunity sObject to opportunity wrapper mapping
    */
    @isTest
    private static void it_should_MapOpportunityToWrapper() {
        Opportunity expectedOpportunity = [SELECT Id, Name, StageName, Amount FROM Opportunity LIMIT 1];

        Test.startTest();
            ExampleOpportunityWrapper actualExampleOpportunityWrapper = new ExampleOpportunityWrapper(expectedOpportunity);
        Test.stopTest();

        assertOpportunityMappings(expectedOpportunity, actualExampleOpportunityWrapper);
    }

    /**
    * @description asserts opportunity sObject mapping to opportunity wrapper
    * @param Opportunity Opportunity
    * @param ExampleOpportunityWrapper wrapper
    */
    public static void assertOpportunityMappings(Opportunity Opportunity, ExampleOpportunityWrapper wrapper) {
        System.assertEquals(Opportunity.Id, wrapper.opportunityId);
        System.assertEquals(Opportunity.Name, wrapper.opportunityName);
        System.assertEquals(Opportunity.StageName, wrapper.opportunityStage);
        System.assertEquals(Integer.valueOf(Opportunity.Amount), wrapper.opportunityAmount);
    }
}