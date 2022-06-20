/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class TerritoryRepository {
    public static List<Territory__c> getTerritoriesByIds(Set<Id> territoryIds) {
        return [
                SELECT Id, Name
                FROM Territory__c
                WHERE Id IN :territoryIds
        ];
    }

    public static Set<Id> getChildIdsOfTerritories(Set<Id> territoryIds) {
        final Set<Id> childrenIds = new Set<Id>();
        for (Territory__c territory : [SELECT Id FROM Territory__c WHERE Territory__c IN :territoryIds]) {
            childrenIds.add(territory.Id);
        }
        return childrenIds;
    }
}