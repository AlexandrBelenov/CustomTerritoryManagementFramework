/**
 * Created by alexanderbelenov on 17.06.2022.
 */

public with sharing class RevokeTerritorySharingAccessBatch implements Database.Batchable<Territory__c> {

    private Set<Id> rootTerritoriesIds;
    private Id revokeToUserId;

    private PermissionService permissionServ;

    public RevokeTerritorySharingAccessBatch(Set<Id> rootTerritoriesIds, Id revokeToUserId) {
        this.rootTerritoriesIds = rootTerritoriesIds;
        this.revokeToUserId = revokeToUserId;
        this.permissionServ = PermissionService.getInstance();
    }

    public void execute(Database.BatchableContext context, List<Territory__c> territories) {
        final Set<Id> territoryIds = Utility.getIds(territories);
        // get Accounts of Territories
        final Map<Id, Account> accountsOfTerritories = AccountRepository.getAccountsOfTerritories(territoryIds);
        // get references of the accounts
        final Set<Id> accountIds = accountsOfTerritories.keySet();
        // get contacts
        final Map<Id, Contact> contactMap = ContactRepository.getContactsOnlyFromReferencesWithAccounts(accountIds);
        final Set<Id> contactIds = contactMap.keySet();

        this.permissionServ.removeAccountPermissions(accountIds, this.revokeToUserId, Constants.ROW_CAUSE_MANUAL);
        this.permissionServ.removeContactPermissions(contactIds, this.revokeToUserId, Constants.ROW_CAUSE_MANUAL);
    }

    public void finish(Database.BatchableContext context) {
        Set<Id> childrenIds = TerritoryRepository.getChildIdsOfTerritories(this.rootTerritoriesIds);
        if (!childrenIds.isEmpty()) {
            RevokeTerritorySharingAccessBatch processChildren = new RevokeTerritorySharingAccessBatch(
                    childrenIds,
                    this.revokeToUserId
            );
            Database.executeBatch(processChildren);
        }
    }

    public Iterable<Territory__c> start(Database.BatchableContext context) {
        return TerritoryRepository.getTerritoriesByIds(this.rootTerritoriesIds);
    }
}