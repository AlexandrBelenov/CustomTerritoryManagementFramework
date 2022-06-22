/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class RevokeTerritorySharingAccessBatchTest {
    @IsTest static void testDeleteBehavior() {
        StaticTest.setDoNotRunTrigger(); // do not run trigger
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Territory__c territory = new Territory__c(Name='Territory1');
        insert territory;
        Account account = new Account(Name='Account1', Territory__c=territory.Id);
        insert account;
        Contact contact = new Contact(FirstName='Joe', LastName='Smith');
        insert contact;
        Reference__c reference = new Reference__c(
                Name = 'Reference1',
                Account__c = account.Id,
                Contact__c = contact.Id
        );
        insert reference;
        AccountShare accountShare = new AccountShare(
                AccountId = account.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                AccountAccessLevel = Constants.ACCESS_LEVEL_EDIT,
                OpportunityAccessLevel = Constants.ACCESS_LEVEL_NONE,
                CaseAccessLevel = Constants.ACCESS_LEVEL_NONE,
                ContactAccessLevel = Constants.ACCESS_LEVEL_NONE
        );
        insert accountShare;
        ContactShare contactShare = new ContactShare(
                ContactId = contact.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                ContactAccessLevel = Constants.ACCESS_LEVEL_EDIT
        );
        insert contactShare;



        Test.startTest();
        RevokeTerritorySharingAccessBatch batch = new RevokeTerritorySharingAccessBatch(
                new Set<Id> {territory.Id},
                salesUser.Id
        );
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();

        Integer contactSharesCount = [
                SELECT COUNT()
                FROM ContactShare
                WHERE ContactId=:contact.Id
                AND UserOrGroupId=:salesUser.Id
                AND RowCause=:Constants.ROW_CAUSE_MANUAL
        ];
        Integer accountSharesCount = [
                SELECT COUNT()
                FROM AccountShare
                WHERE AccountId=:contact.Id
                AND UserOrGroupId=:salesUser.Id
                AND RowCause=:Constants.ROW_CAUSE_MANUAL
        ];
        System.assertEquals(contactSharesCount, 0);
        System.assertEquals(accountSharesCount, 0);
    }

    @IsTest static void testBatchLeverage() {
        StaticTest.setDoNotRunTrigger();
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Territory__c firstLevel = new Territory__c(Name='FirstLevel', Territory__c=root.Id);
        insert firstLevel;

        Test.startTest();
        RevokeTerritorySharingAccessBatch batch = new RevokeTerritorySharingAccessBatch(
                new Set<Id> {root.Id},
                salesUser.Id
        );
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();
    }
}