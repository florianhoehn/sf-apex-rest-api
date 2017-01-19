/**
* ExampleAccountWrapperTestMVN.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: tests ExampleAccountWrapperMVN
**/
@isTest
public class ExampleAccountWrapperTestMVN {
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
            ExampleAccountWrapperMVN actualExampleAccountWrapper = new ExampleAccountWrapperMVN(expectedAccount);
        Test.stopTest();

        assertAccountMappings(expectedAccount, actualExampleAccountWrapper);
    }

    /**
    * @description tests account wrapper to account sObject conversion for callout response
    */
    @isTest
    private static void it_should_ConvertWrapperToAccount() {
        Account testAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating FROM Account LIMIT 1];
        ExampleAccountWrapperMVN expectedExampleAccountWrapper = createExampleAccountWrapper(testAccount.Id);

        Test.startTest();
            Account actualUpdatedAccount = (Account)expectedExampleAccountWrapper.convert();
        Test.stopTest();

        assertAccountMappings(actualUpdatedAccount, expectedExampleAccountWrapper);
    }

    /**
    * @description creates account wrapper
    * @param Id accountId
    * @return ￼ExampleAccountWrapperMVN wrapper
    */
    public static ExampleAccountWrapperMVN createExampleAccountWrapper(Id accountId) {
        ExampleAccountWrapperMVN wrapper = new ExampleAccountWrapperMVN();
        wrapper.accountId = accountId;
        wrapper.accountRating = 'Wrap Test Rating';
        return wrapper;
    }

    /**
    * @description asserts account sObject mapping to account wrapper
    * @param Account account
    * @param ExampleAccountWrapperMVN wrapper
    */
    public static void assertAccountMappings(Account account, ExampleAccountWrapperMVN wrapper) {
        System.assertEquals(account.Id, wrapper.accountId);
        System.assertEquals(account.Name, wrapper.accountName);
        System.assertEquals(account.Type, wrapper.accountType);
        if(wrapper.isBigPlayer != null) {
            System.assertEquals(account.AnnualRevenue > ExampleAccountWrapperMVN.BIG_PLAYER_LINE, wrapper.isBigPlayer);
        }
        System.assertEquals(account.Rating, wrapper.accountRating);
        for(Integer counter = 0; counter < account.Opportunities.size(); counter++) {
            ExampleOpportunityWrapperTestMVN.assertOpportunityMappings(account.Opportunities.get(counter), wrapper.opportunities.get(counter));
        }
    }
}