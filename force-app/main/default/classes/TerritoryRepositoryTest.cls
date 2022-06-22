/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class TerritoryRepositoryTest {
    @IsTest static void testGetTerritoriesByIds() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='Territory2', Territory__c=territory1.Id);
        insert territory2;
        Territory__c territory3 = new Territory__c(Name='Territory3', Territory__c=territory2.Id);
        insert territory3;

        List<Territory__c> fetchedTerritories = TerritoryRepository.getTerritoriesByIds(new Set<Id>{territory1.Id, territory2.Id});
        System.assertEquals(fetchedTerritories.size(), 2);
    }

    @IsTest static void testGetChildIdsOfTerritories() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='Territory2', Territory__c=territory1.Id);
        Territory__c territory3 = new Territory__c(Name='Territory3', Territory__c=territory1.Id);
        Territory__c territory4 = new Territory__c(Name='Territory4');
        insert new List<Territory__c>{territory2, territory3, territory4};

        Set<Id> children = TerritoryRepository.getChildIdsOfTerritories(new Set<Id> {territory1.Id});
        System.assertEquals(children.size(), 2);
        System.assertEquals(children, new Set<Id>{territory2.Id, territory3.Id});
    }
}