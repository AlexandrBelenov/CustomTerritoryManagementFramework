/**
 * Created by alexanderbelenov on 19.06.2022.
 */

public with sharing class TerritoryTriggerHandler {

    private TerritoryService terrService = TerritoryService.getInstance();
    private TerritoryTriggerHandler() {}

    public void beforeInsert(List<Territory__c> territories) {
        final List<Territory__c> duplicates = this.terrService.findDuplicatesWithSameParent(territories);
        if (!duplicates.isEmpty()) {
            this.addError(duplicates, Label.Territory_Name_Already_Exists);
        }
    }

    public void beforeUpdate(Map<Id, Territory__c> newMap, Map<Id, Territory__c> oldMap) {
        final List<Territory__c> updatedTerritories = this.terrService.getTerritoriesWithChangedNames(newMap, oldMap);
        final List<Territory__c> duplicates = this.terrService.findDuplicatesWithSameParent(updatedTerritories);
        if (!duplicates.isEmpty()) {
            this.addError(duplicates, Label.Territory_Name_Already_Exists);
        }
    }

    public void beforeDelete(Map<Id, Territory__c> territoryMap) {
        // Check children. If has one - error
        final List<Territory__c> hasChildrenList = this.terrService.findTerritoriesWithChildren(territoryMap);
        if (!hasChildrenList.isEmpty()) {
            this.addError(hasChildrenList, Label.Cannot_Delete_Has_Child_Territories);
        }
        // Check accounts with the territory. If has assigned account - error
        final List<Territory__c> hasAccountsList = this.terrService.findTerritoriesWithAccounts(territoryMap);
        if (!hasAccountsList.isEmpty()) {
            this.addError(hasAccountsList, Label.Cannot_Delete_Has_Assigned_Accounts);
        }

    }

    private void addError(List<Territory__c> territories, String message) {
        for (Territory__c territory : territories) {
            territory.addError(message);
        }
    }

    private static TerritoryTriggerHandler instance = null;
    public static TerritoryTriggerHandler getInstance() {
        if (instance == null) {
            instance = new TerritoryTriggerHandler();
        }
        return instance;
    }

}