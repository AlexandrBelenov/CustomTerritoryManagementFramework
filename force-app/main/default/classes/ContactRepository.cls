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

}