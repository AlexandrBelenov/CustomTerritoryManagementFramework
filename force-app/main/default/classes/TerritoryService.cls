/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class TerritoryService {
    private TerritoryService() {}

    public List<Territory__c> findDuplicatesWithSameParent(List<Territory__c> territories) {
        // get all parents and names
        final Set<Id> territoryParentIds = new Set<Id>();
        final Set<String> territoryNames = new Set<String>();
        for (Territory__c territory : territories) {
            if (territory.Territory__c != null) {
                territoryParentIds.add(territory.Territory__c);
            }
            if (territory.Name != null) {
                territoryNames.add(territory.Name);
            }
        }
        // query territories with the parents and names
        final List<Territory__c> savedTerritories = null;
        // compare by Name and Parent
        final List<Territory__c> differences = new List<Territory__c>();
        for (Territory__c savedTerritory : [
                SELECT Id, Name, Territory__c
                FROM Territory__c
                WHERE Territory__c IN :territoryParentIds
                AND Name IN :territoryNames]) {
            for (Territory__c territory : territories) {
                if (savedTerritory.Territory__c.equals(territory.Territory__c)
                && savedTerritory.Name.equals(territory.Name)) {
                    differences.add(savedTerritory);
                    break;
                }
            }
        }
        return differences;
    }

    public List<Territory__c> getTerritoriesWithChangedNames(Map<Id, Territory__c> newMap, Map<Id, Territory__c> oldMap) {
        final List<Territory__c> result = new List<Territory__c>();
        for (Id id : newMap.keySet()) {
            final String newName = newMap.get(id).Name;
            final String oldName = oldMap.get(id).Name;
            if (newName != oldName) {
                result.add(newMap.get(id));
            }
        }
        return result;
    }

    public List<Territory__c> findTerritoriesWithChildren(Map<Id, Territory__c> territoryMap) {
        final Map<Id, Territory__c> childTerritories = new Map<Id, Territory__c>([
                SELECT Id, Name, Territory__c
                FROM Territory__c
                WHERE Territory__c IN :territoryMap.keySet()
        ]);

        final Set<Territory__c> result = new Set<Territory__c>();
        for (Id id : childTerritories.keySet()) {
            final Id parentId = childTerritories.get(id).Territory__c;
            result.add(territoryMap.get(parentId));
        }

        return new List<Territory__c>(result);
    }

    public List<Territory__c> findTerritoriesWithAccounts(Map<Id, Territory__c> territoryMap) {
        final Map<Id, Account> assignedAccounts = new Map<Id, Account>([
                SELECT Id, Name, Territory__c
                FROM Account
                WHERE Territory__c IN :territoryMap.keySet()
        ]);
        final Set<Territory__c> result = new Set<Territory__c>();
        for (Id id : assignedAccounts.keySet()) {
            final Id territoryId = assignedAccounts.get(id).Territory__c;
            result.add(territoryMap.get(territoryId));
        }
        return new List<Territory__c>(result);
    }

    private static TerritoryService instance = null;
    public static TerritoryService getInstance() {
        if (instance == null) {
            instance = new TerritoryService();
        }
        return instance;
    }
}