/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class TerritoryService {
    private TerritoryService() {}

    public List<Territory__c> findDuplicatesInInput(List<Territory__c> territories) {
        final Map<String, Territory__c> idParentName_Territories = new Map<String, Territory__c>();
        for (Territory__c territory : territories) {
            final String compoundKey = territory.Territory__c + territory.Name;
            idParentName_Territories.put(compoundKey, territory);
        }
        for (Territory__c territory : idParentName_Territories.values()) {
            territories.add(territory);
        }
        return territories;
    }

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
                    differences.add(territory);
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
        List<Territory__c> result = new List<Territory__c>();
        Map<Id, Territory__c> childTerritories = new Map<Id, Territory__c>([
                SELECT Id, Name, Territory__c
                FROM Territory__c
                WHERE Territory__c IN :territoryMap.keySet()
        ]);

        for (Id id : childTerritories.keySet()) {
            final Id parentId = childTerritories.get(id).Territory__c;
            result.add(territoryMap.get(parentId));
        }

        return result;
    }

    private static TerritoryService instance = null;
    public static TerritoryService getInstance() {
        if (instance == null) {
            instance = new TerritoryService();
        }
        return instance;
    }
}