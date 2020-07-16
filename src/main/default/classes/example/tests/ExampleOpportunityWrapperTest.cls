/**
* @author Florian Hoehn
* tests ExampleOpportunityWrapper
**/
@isTest
public class ExampleOpportunityWrapperTest {
    /**
    * setup test data for this class
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
    * tests opportunity sObject to opportunity wrapper mapping
    */
    @isTest
    private static void mapOpportunityToWrapper() {
        Opportunity expectedOpportunity = [SELECT Id, Name, StageName, Amount FROM Opportunity LIMIT 1];

        Test.startTest();
            ExampleOpportunityWrapper actualExampleOpportunityWrapper = new ExampleOpportunityWrapper(expectedOpportunity);
        Test.stopTest();

        System.assertEquals(expectedOpportunity.Id, actualExampleOpportunityWrapper.opportunityId, 'Opportunity Id does not match');
        assertOpportunityMappings(expectedOpportunity, actualExampleOpportunityWrapper);
    }

    /**
    * asserts opportunity sObject mapping to opportunity wrapper
    * @param Opportunity Opportunity
    * @param ExampleOpportunityWrapper wrapper
    */
    @SuppressWarnings('PMD.ApexUnitTestMethodShouldHaveIsTestAnnotation')
    public static void assertOpportunityMappings(Opportunity opportunity, ExampleOpportunityWrapper wrapper) {
        System.assertEquals(opportunity.Id, wrapper.opportunityId, 'Opportunity Id does not match');
        System.assertEquals(opportunity.Name, wrapper.opportunityName, 'Opportunity Name does not match');
        System.assertEquals(opportunity.StageName, wrapper.opportunityStage, 'Opportunity Stage does not match');
        System.assertEquals(Integer.valueOf(opportunity.Amount), wrapper.opportunityAmount, 'Opportunity Amount does not match');
    }
}