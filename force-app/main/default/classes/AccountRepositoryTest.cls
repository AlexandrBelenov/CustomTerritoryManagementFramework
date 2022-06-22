/**
 * Created by alexanderbelenov on 22.06.2022.
 */
@IsTest
private class AccountRepositoryTest {

    @IsTest
    static void testGetAccountByTerritory() {
        List<Territory__c> territories = new List<Territory__c>();
        territories.add(new Territory__c(Name='Ukraine'));
        territories.add(new Territory__c(Name='Germany'));
        insert territories;
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account1', Territory__c=territories[0].Id));
        accounts.add(new Account(Name='Account2', Territory__c=territories[1].Id));
        insert accounts;

        Test.startTest();
        Set<Id> ids = new Set<Id>();
        ids.add(territories[0].Id);
        Map<Id, Account> accountMap = AccountRepository.getAccountsOfTerritories(ids);
        Test.stopTest();

        System.assertEquals(accountMap.size(), 1);
        System.assertEquals(accountMap.keySet(), new Set<Id> {accounts[0].Id});
    }

}