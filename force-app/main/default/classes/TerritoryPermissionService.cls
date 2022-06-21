/**
 * Created by alexanderbelenov on 21.06.2022.
 */

public with sharing class TerritoryPermissionService {
    private TerritoryPermissionService() {}

    public void grantAccessFor(Map<Id, TerrUser__c> terrUserMap) {
        for (Id id : terrUserMap.keySet()) {
            final TerrUser__c terrUser = terrUserMap.get(id);
            final Set<Id> headTerritory = new Set<Id> {terrUser.Territory__c};
            GrantTerritorySharingAccessBatch grantBatch
                    = new GrantTerritorySharingAccessBatch(
                            headTerritory,
                            terrUser.User__c
                    );
            Database.executeBatch(grantBatch);
        }
    }

    public void revokeAccessFor(Map<Id, TerrUser__c> terrUserMap) {
        for (Id id : terrUserMap.keySet()) {
            final TerrUser__c terrUser = terrUserMap.get(id);
            final Set<Id> headTerritory = new Set<Id> {terrUser.Territory__c};
            RevokeTerritorySharingAccessBatch revokeBatch
                    = new RevokeTerritorySharingAccessBatch(
                            headTerritory,
                            terrUser.User__c
                    );
            Database.executeBatch(revokeBatch);
        }
    }

    private static TerritoryPermissionService instance;
    public static TerritoryPermissionService getInstance() {
        if (instance == null) {
            instance = new TerritoryPermissionService();
        }
        return instance;
    }
}