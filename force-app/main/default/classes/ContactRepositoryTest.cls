/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class ContactRepositoryTest {
    @IsTest static void testGetContactsById() {
        Contact contact1 = new Contact(LastName='LastName1');
        Contact contact2 = new Contact(LastName='LastName2');
        Contact contact3 = new Contact(LastName='LastName3');
        insert new List<Contact> {contact1, contact2, contact3};

        Map<Id, Contact> contactMap = ContactRepository.getContactsById(new Set<Id>{contact2.Id});
        System.assertEquals(contactMap.size(), 1);
        System.assertEquals(contactMap.keySet(), new Set<Id>{contact2.Id});
    }
    @IsTest static void testGetContactsOnlyFromReferencesWithAccounts() {
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

        Map<Id, Contact> contactMap = ContactRepository.getContactsOnlyFromReferencesWithAccounts(new Set<Id> {account1.Id});

        System.assertEquals(contactMap.size(), 1);
        System.assertEquals(contactMap.keySet(), new Set<Id> {contact1.Id});

    }


}