/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class ReferenceRepositoryTest {
    @IsTest static void testGetReferenceOfAccounts() {
        Account account1 = new Account(Name='Account1');
        Account account2 = new Account(Name='Account2');
        insert new List<Account>{account1, account2};

        Contact contact1 = new Contact(LastName='LastName1');
        Contact contact2 = new Contact(LastName='LastName2');
        Contact contact3 = new Contact(LastName='LastName3');
        insert new List<Contact> {contact1, contact2, contact3};

        Reference__c reference1 = new Reference__c(Account__c=account1.Id, Contact__c=contact1.Id);
        Reference__c reference2 = new Reference__c(Account__c=account1.Id, Contact__c=contact2.Id);
        Reference__c reference3 = new Reference__c(Account__c=account2.Id, Contact__c=contact2.Id);
        Reference__c reference4 = new Reference__c(Account__c=account2.Id, Contact__c=contact3.Id);
        insert new List<Reference__c> {reference1, reference2, reference3, reference4};

        Map<Id,Reference__c> referenceMap = ReferenceRepository.getReferenceOfAccounts(new Set<Id> {account1.Id});

        System.assertEquals(referenceMap.size(), 2);
        System.assertEquals(referenceMap.keySet(), new Set<Id> {reference1.Id, reference2.Id});
    }
}