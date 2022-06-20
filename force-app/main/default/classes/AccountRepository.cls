/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class AccountRepository {
    public static Map<Id, Account> getAccountsOfTerritories(Set<Id> territories) {
        return new Map<Id, Account>([
                SELECT Id
                FROM Account
                WHERE Territory__c IN :territories
        ]);
    }

}