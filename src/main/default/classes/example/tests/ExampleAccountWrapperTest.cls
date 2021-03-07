/**
* @author Florian Hoehn
* tests ExampleAccountWrapper
**/
@isTest
public class ExampleAccountWrapperTest {
    /**
    * setup test data for this class
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
    * tests account sObject to account wrapper mapping for callout
    */
    @isTest
    private static void mapAccountToWrapper() {
        Account expectedAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating,
                                          (SELECT Id, Name, Amount, StageName FROM Opportunities)
                                     FROM Account
                                    LIMIT 1];

        Test.startTest();
            ExampleAccountWrapper actualExampleAccountWrapper = new ExampleAccountWrapper(expectedAccount);
        Test.stopTest();

        System.assertEquals(expectedAccount.Id, actualExampleAccountWrapper.accountId, 'Account Id does not match');
        assertAccountMappings(expectedAccount, actualExampleAccountWrapper);
    }

    /**
    * tests account wrapper to account sObject conversion for callout response
    */
    @isTest
    private static void convertWrapperToAccount() {
        Account testAccount = [SELECT Id, Name, Type, AnnualRevenue, Rating FROM Account LIMIT 1];
        ExampleAccountWrapper expectedExampleAccountWrapper = createExampleAccountWrapper(testAccount.Id);

        Test.startTest();
            Account actualUpdatedAccount = (Account)expectedExampleAccountWrapper.convert();
        Test.stopTest();

        System.assertEquals(actualUpdatedAccount.Id, expectedExampleAccountWrapper.accountId, 'Account Id does not match');
        assertAccountMappings(actualUpdatedAccount, expectedExampleAccountWrapper);
    }

    /**
    * creates account wrapper
    * @param Id accountId
    * @return ￼ExampleAccountWrapper wrapper
    */
    public static ExampleAccountWrapper createExampleAccountWrapper(Id accountId) {
        ExampleAccountWrapper wrapper = new ExampleAccountWrapper();
        wrapper.accountId = accountId;
        wrapper.accountRating = 'Wrap Test Rating';
        return wrapper;
    }

    /**
    * asserts account sObject mapping to account wrapper
    * @param Account account
    * @param ExampleAccountWrapper wrapper
    */
    @SuppressWarnings('PMD.ApexUnitTestMethodShouldHaveIsTestAnnotation')
    public static void assertAccountMappings(Account account, ExampleAccountWrapper wrapper) {
        System.assertEquals(account.Id, wrapper.accountId, 'Account Id does not match');
        System.assertEquals(account.Name, wrapper.accountName, 'Account Name does not match');
        System.assertEquals(account.Type, wrapper.accountType, 'Account Type does not match');
        if(wrapper.isBigPlayer != null) {
            System.assertEquals(account.AnnualRevenue > ExampleAccountWrapper.BIGPLAYERLINE, wrapper.isBigPlayer, 'Account isBigPlayer does not match');
        }
        System.assertEquals(account.Rating, wrapper.accountRating, 'Account Rating does not match');
        for(Integer counter = 0; counter < account.Opportunities.size(); counter++) {
            ExampleOpportunityWrapperTest.assertOpportunityMappings(account.Opportunities.get(counter), wrapper.opportunities.get(counter));
        }
    }
}