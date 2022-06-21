/**
 * Created by alexanderbelenov on 21.06.2022.
 */

public with sharing class TerrUserTriggerHandler {

    private TerritoryPermissionService permissionService;

    private TerrUserTriggerHandler() {
        this.permissionService = TerritoryPermissionService.getInstance();
    }

    public void afterInsert(Map<Id, TerrUser__c> newMap) {
        this.permissionService.grantAccessFor(newMap);
    }

    public void afterDelete(Map<Id, TerrUser__c> oldMap) {
        this.permissionService.revokeAccessFor(oldMap);
    }

    private static TerrUserTriggerHandler instance;
    public static TerrUserTriggerHandler getInstance() {
        if (instance == null) {
            instance = new TerrUserTriggerHandler();
        }
        return instance;
    }
}