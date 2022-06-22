/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class GrantTerritorySharingAccessBatchTest {
    @IsTest static void testBatchLimits() {
        StaticTest.setDoNotRunTrigger(); // do not run trigger

        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        List<Territory__c> territories = new List<Territory__c>();
        for (Integer i = 0; i < 200; i++) {
            territories.add(new Territory__c(Name='Territory' + i));
        }
        insert territories;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2000; i++) {
            Integer index = i / 10;
            accounts.add(new Account(Name='Account'+i, Territory__c=territories[index].Id));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 2000; i++) {
            contacts.add(new Contact(FirstName='Joe', LastName='Smith' + i));
        }
        insert contacts;

        List<Reference__c> references = new List<Reference__c>();
        for (Integer i = 0; i < 2000; i++) {
            Integer index = i / 10;
            references.add(new Reference__c(
                    Name = 'Reference' + i,
                    Account__c = accounts.get(index).Id,
                    Contact__c = contacts.get(i).Id
            ));
        }
        insert references;

        Set<Id> territoryIds = new Set<Id>();
        for (Territory__c territory : territories) {
            territoryIds.add(territory.Id);
        }

        Test.startTest();
        GrantTerritorySharingAccessBatch batch = new GrantTerritorySharingAccessBatch(
                territoryIds,
                salesUser.Id
        );
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();
    }

    @IsTest static void testBatchLeverage() {
        StaticTest.setDoNotRunTrigger();
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Territory__c firstLevel = new Territory__c(Name='FirstLevel', Territory__c=root.Id);
        insert firstLevel;

        Test.startTest();
        GrantTerritorySharingAccessBatch batch = new GrantTerritorySharingAccessBatch(
                new Set<Id> {root.Id},
                salesUser.Id
        );
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();
    }
}