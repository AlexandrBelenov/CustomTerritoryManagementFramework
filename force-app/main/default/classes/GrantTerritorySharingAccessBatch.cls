/**
 * Created by alexanderbelenov on 17.06.2022.
 */

public with sharing class GrantTerritorySharingAccessBatch implements Database.Batchable<Territory__c> {

    private Set<Id> rootTerritoriesIds;
    private Id grantToUserId;

    private PermissionService permissionServ;

    public GrantTerritorySharingAccessBatch(Set<Id> rootTerritoriesIds, Id grantToUserId) {
        this.rootTerritoriesIds = rootTerritoriesIds;
        this.grantToUserId = grantToUserId;
        this.permissionServ = PermissionService.getInstance();
    }

    public void execute(Database.BatchableContext context, List<Territory__c> territories) {
        final Set<Id> territoryIds = Utility.getIds(territories);
        // get Accounts of Territories
        final Map<Id, Account> accountsOfTerritories = AccountRepository.getAccountsOfTerritories(territoryIds);
        // get references of the accounts
        final Set<Id> accountIds = accountsOfTerritories.keySet();
        final Map<Id, Reference__c> referencesOfAccounts = ReferenceRepository.getReferenceOfAccounts(accountIds);
        // get contacts of the references
        final Set<Id> contactIds = new Set<Id>();
        for (Id key : referencesOfAccounts.keySet()) {
            final Id contactId = referencesOfAccounts.get(key).Contact__c;
            if (contactId != null) {
                contactIds.add(contactId);
            }
        }
        // get permissions to accounts
        final Set<Id> accountIdsWithoutPermission = this.permissionServ.getAccountIdsWithoutPermissions(
                accountIds,
                this.grantToUserId,
                Constants.ROW_CAUSE_MANUAL
        );
        final List<AccountShare> accountShareList = this.permissionServ.getAccountShares(
                accountIdsWithoutPermission,
                this.grantToUserId,
                Constants.ACCESS_LEVEL_EDIT,
                Constants.ROW_CAUSE_MANUAL,
                Constants.ACCESS_LEVEL_NONE,
                Constants.ACCESS_LEVEL_NONE,
                Constants.ACCESS_LEVEL_NONE
        );
        // get permissions to contacts
        final Set<Id> contactIdsWithoutPermission = this.permissionServ.getContactIdsWithoutPermissions(
                contactIds,
                this.grantToUserId,
                Constants.ROW_CAUSE_MANUAL
        );

        final List<ContactShare> contactShareList = this.permissionServ.getContactShares(
                contactIdsWithoutPermission,
                this.grantToUserId,
                Constants.ACCESS_LEVEL_EDIT,
                Constants.ROW_CAUSE_MANUAL
        );

        try {
            insert accountShareList;
            insert contactShareList;
        } catch (Exception e) {
            System.debug(e);
            throw e;
        }
    }

    public void finish(Database.BatchableContext context) {
        Set<Id> childrenIds = TerritoryRepository.getChildIdsOfTerritories(this.rootTerritoriesIds);
        if (!childrenIds.isEmpty()) {
            GrantTerritorySharingAccessBatch processChildren = new GrantTerritorySharingAccessBatch(
                    childrenIds,
                    this.grantToUserId
            );
            Database.executeBatch(processChildren);
        }
    }

    public Iterable<Territory__c> start(Database.BatchableContext context) {
        return TerritoryRepository.getTerritoriesByIds(this.rootTerritoriesIds);
    }
}

