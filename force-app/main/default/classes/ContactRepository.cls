/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class ContactRepository {
    public static Map<Id, Contact> getContactsById(Set<Id> contactsIds) {
        return new Map<Id, Contact>([
                SELECT Id, Name
                FROM Contact
                WHERE Id In :contactsIds
        ]);
    }

    public static Map<Id, Contact> getContactsOnlyFromReferencesWithAccounts(Set<Id> accountIds) {
        Map<Id, Contact> contactMap = new Map<Id, Contact>([
                SELECT Id, Name
                FROM Contact
                WHERE Id IN (SELECT Contact__c From Reference__c WHERE Account__c IN :accountIds)
                AND Id NOT IN (SELECT Contact__c From Reference__c WHERE Account__c NOT IN :accountIds)
        ]);
        return contactMap;
    }

}