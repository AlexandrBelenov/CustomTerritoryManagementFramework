/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class ReferenceRepository {
    public static Map<Id, Reference__c> getReferenceOfAccounts(Set<Id> accountIds) {
        return new Map<Id, Reference__c>([
                SELECT Id, Account__c, Contact__c
                FROM Reference__c
                WHERE Account__c In :accountIds
        ]);
    }
}