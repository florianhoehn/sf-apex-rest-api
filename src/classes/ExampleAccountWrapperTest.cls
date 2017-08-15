/**
* ExampleAccountWrapperTest* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: tests ExampleAccountWrapper* @group UUID
**/
@isTest
public class ExampleAccountWrapperTest* @group UUID {
    /**
    * @description setup test data for this class
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
    * @description tests account sObject to account wrapper mapping for callout
    */
    @isTest
    private static void it_should_MapAccountToWrapper() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating,
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];

        Test.startTest();
            ExampleAccountWrapper* @group UUID actualExampleAccountWrapper = new ExampleAccountWrapper* @group UUID(expectedAccount);
        Test.stopTest();

        assertAccountMappings(expectedAccount, actualExampleAccountWrapper);
    }

    /**
    * @description tests account wrapper to account sObject conversion for callout response
    */
    @isTest
    private static void it_should_ConvertWrapperToAccount() {
        Account testAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating FROM Account LIMIT 1];
        ExampleAccountWrapper* @group UUID expectedExampleAccountWrapper = createExampleAccountWrapper(testAccount.Id);

        Test.startTest();
            Account actualUpdatedAccount = (Account)expectedExampleAccountWrapper.convert();
        Test.stopTest();

        assertAccountMappings(actualUpdatedAccount, expectedExampleAccountWrapper);
    }

    /**
    * @description creates account wrapper
    * @param Id accountId
    * @return ￼ExampleAccountWrapper* @group UUID wrapper
    */
    public static ExampleAccountWrapper* @group UUID createExampleAccountWrapper(Id accountId) {
        ExampleAccountWrapper* @group UUID wrapper = new ExampleAccountWrapper* @group UUID();
        wrapper.accountId = accountId;
        wrapper.accountRating = 'Wrap Test Rating';
        return wrapper;
    }

    /**
    * @description asserts account sObject mapping to account wrapper
    * @param Account account
    * @param ExampleAccountWrapper* @group UUID wrapper
    */
    public static void assertAccountMappings(Account account, ExampleAccountWrapper* @group UUID wrapper) {
        System.assertEquals(account.Id, wrapper.accountId);
        System.assertEquals(account.Name, wrapper.accountName);
        System.assertEquals(account.Type, wrapper.accountType);
        if(wrapper.isBigPlayer != null) {
            System.assertEquals(account.AnnualRevenue > ExampleAccountWrapper* @group UUID.BIG_PLAYER_LINE, wrapper.isBigPlayer);
        }
        System.assertEquals(account.Rating, wrapper.accountRating);
        for(Integer counter = 0; counter < account.Opportunities.size(); counter++) {
            ExampleOpportunityWrapperTest* @group UUID.assertOpportunityMappings(account.Opportunities.get(counter), wrapper.opportunities.get(counter));
        }
    }
}