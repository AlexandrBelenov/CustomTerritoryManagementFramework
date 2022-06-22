/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class TerritoryServiceTest {
    @IsTest static void testFindDuplicatesWithSameParentSuccess() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='Territory2', Territory__c=territory1.Id);
        insert territory2;
        Territory__c territory3 = new Territory__c(Name='Territory3', Territory__c=territory2.Id); //duplicates
        insert territory3;
        Territory__c territory4 = new Territory__c(Name='Territory3', Territory__c=territory2.Id); //duplicates

        TerritoryService service = TerritoryService.getInstance();
        List<Territory__c> duplicate = service.findDuplicatesWithSameParent(new List<Territory__c> {territory4});

        System.assertEquals(duplicate.size(), 1);
        System.assertEquals(duplicate.get(0).Id, territory3.Id);
    }

    @IsTest static void testGetTerritoriesWithChangedNames() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        Territory__c territory2 = new Territory__c(Name='Territory2');
        insert territory1;
        insert territory2;
        Territory__c territory1_clone = territory1.clone(true);
        territory1_clone.Name = 'Territory1Clone';
        Territory__c territory2_clone = territory2.clone(true);
        Map<Id, Territory__c> oldMap = new Map<Id, Territory__c>();
        oldMap.put(territory1.Id, territory1);
        oldMap.put(territory2.Id, territory2);
        Map<Id, Territory__c> newMap = new Map<Id, Territory__c>();
        newMap.put(territory1_clone.Id, territory1_clone);
        newMap.put(territory2_clone.Id, territory2_clone);

        TerritoryService service = TerritoryService.getInstance();
        List<Territory__c> changedNames = service.getTerritoriesWithChangedNames(newMap, oldMap);
        System.assertEquals(changedNames.size(), 1);
    }

    @IsTest static void testFindTerritoriesWithChildren() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='Territory2', Territory__c=territory1.Id);
        insert territory2;
        Territory__c territory3 = new Territory__c(Name='Territory3');
        insert territory3;

        Map<Id, Territory__c> parentsMaybeWithChildren = new Map<Id, Territory__c>();
        parentsMaybeWithChildren.put(territory1.Id, territory1);
        parentsMaybeWithChildren.put(territory3.Id, territory3);

        TerritoryService service = TerritoryService.getInstance();
        List<Territory__c> parentsWithChildren = service.findTerritoriesWithChildren(parentsMaybeWithChildren);
        System.assertEquals(parentsWithChildren.size(), 1);
        System.assertEquals(parentsWithChildren.get(0).Id, territory1.Id);
    }

    @IsTest static void testFindTerritoriesWithAccounts() {
        Territory__c territory1 = new Territory__c(Name='Territory1');
        Territory__c territory2 = new Territory__c(Name='Territory2');
        insert new List<Territory__c>{territory1, territory2};
        Map<Id, Territory__c> territoryMap = new Map<Id, Territory__c>{territory1.Id => territory1, territory2.Id => territory2};
        Account account1 = new Account(Name='Account1', Territory__c=territory1.Id);
        Account account2 = new Account(Name='Account2', Territory__c=territory1.Id);
        insert new List<Account>{account1, account2};

        TerritoryService service = TerritoryService.getInstance();
        List<Territory__c> territories = service.findTerritoriesWithAccounts(territoryMap);
        System.assertEquals(territories.size(), 1);
        System.assertEquals(territories.get(0).Id, territory1.Id);
    }

}