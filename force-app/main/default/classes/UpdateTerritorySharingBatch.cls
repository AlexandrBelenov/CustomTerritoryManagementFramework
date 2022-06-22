/**
 * Created by alexanderbelenov on 17.06.2022.
 */

public with sharing class UpdateTerritorySharingBatch implements Database.Batchable<Territory__c> {
    private Set<Id> territoryIds;
//    private Id oldUserId;
//    private Id newUserId;

//    public UpdateTerritorySharingBatch(Set<Id> territoryIds, Id oldUserId, Id newUserId) {
//        this.territoryIds = territoryIds;
//        this.oldUserId = oldUserId;
//        this.newUserId = newUserId;
//    }

    public void execute(Database.BatchableContext context, List<Territory__c> territories) {
//        // get Accounts of Territories
//        final List<Id> accountsIdOfTerritories = new List<Id>();
//        for (Account account : [
//                SELECT Id
//                FROM Account
//                WHERE Territory__c IN :territories]) {
//            accountsIdOfTerritories.add(account.Id);
//        }
//        // get references of the accounts
//        final List<Id> contactsIds = new List<Id>();
//        for (Reference__c reference : [
//                SELECT Id, Account__c, Contact__c
//                FROM Reference__c
//                WHERE Account__c In :accountsIdOfTerritories]) {
//            if (reference.Contact__c != null) {
//                contactsIds.add(reference.Contact__c);
//            }
//        }
//        final List<Contact> contacts = [
//                SELECT Id, Name
//                FROM Contact
//                WHERE Id In :contactsIds
//        ];
//
//        // check if already has access
//        // grant permissions to accounts
//        final List<AccountShare> newAccountShares = new List<AccountShare>();
//        for (Id accountId :accountsIdOfTerritories) {
//            final AccountShare thisAccountShare = new AccountShare(
//                    UserOrGroupId = this.newUserId,
//                    AccountId = accountId,
//                    AccountAccessLevel = Constants.ACCESS_LEVEL_EDIT,
//                    RowCause = Constants.ROW_CAUSE_MANUAL,
//                    OpportunityAccessLevel = Constants.ACCESS_LEVEL_NONE,
//                    CaseAccessLevel = Constants.ACCESS_LEVEL_NONE,
//                    ContactAccessLevel = Constants.ACCESS_LEVEL_NONE
//            );
//            newAccountShares.add(thisAccountShare);
//        }
//
//
//        // check if already has access
//        // grant permissions to contacts
//        final List<ContactShare> newContactShares = new List<ContactShare>();
//        for (Contact contact : contacts) {
//            ContactShare thisContactShare = new ContactShare(
//                    userOrGroupId = this.newUserId,
//                    ContactId = contact.Id,
//                    ContactAccessLevel=Constants.ACCESS_LEVEL_EDIT,
//                    RowCause=Constants.ROW_CAUSE_MANUAL
//            );
//            newContactShares.add(thisContactShare);
//        }
//        try {
//            insert newAccountShares;
//            insert newContactShares;
//        } catch (Exception e) {
//            System.debug(e);
//            throw e;
//        }

    }

    public void finish(Database.BatchableContext context) {
//        Set<Id> childrenIds = new Set<Id>();
//        for (Territory__c territory : [SELECT Id FROM Territory__c WHERE Territory__c IN :territoryIds]) {
//            childrenIds.add(territory.Id);
//        }
//        if (!childrenIds.isEmpty()) {
//            GrantTerritorySharingAccessBatch processChildren = new GrantTerritorySharingAccessBatch(
//                    childrenIds,
//                    this.oldUserId,
//                    this.newUserId
//            );
//            Database.executeBatch(processChildren);
//        }
    }

    public Iterable<Territory__c> start(Database.BatchableContext context) {
        return TerritoryRepository.getTerritoriesByIds(territoryIds);
    }
}