/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class RevokeTerritorySharingAccessBatchTest {
    @IsTest
    static void testDeleteBehavior() {
        StaticTest.setDoNotRunTrigger(); // do not run trigger
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Territory__c territory = new Territory__c(Name='Territory1');
        insert territory;
        Account account = new Account(Name='Account1', Territory__c=territory.Id);
        insert account;

    }
}