/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class TerritoryTriggerTest {
    @IsTest static void testDuplicateNameError() {
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Territory__c territory1 = new Territory__c(Name='UniqueName', Territory__c=root.Id);
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='UniqueName', Territory__c=root.Id);
        Test.startTest();
        Database.SaveResult saveResult = Database.insert(territory2, false);
        Test.stopTest();
        System.assertEquals(saveResult.isSuccess(), false);
    }

    @IsTest static void testUpdate() {
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Territory__c territory1 = new Territory__c(Name='UniqueName', Territory__c=root.Id);
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='AnotherName', Territory__c=root.Id);
        insert territory2;
        territory2.Name = 'UniqueName';
        Test.startTest();
        Database.SaveResult saveResult = Database.insert(territory2, false);
        Test.stopTest();
        System.assertEquals(saveResult.isSuccess(), false);
    }

    @IsTest static void testDeleteHasChildrenFail() {
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Territory__c territory1 = new Territory__c(Name='UniqueName', Territory__c=root.Id);
        insert territory1;
        Territory__c territory2 = new Territory__c(Name='AnotherName', Territory__c=root.Id);
        insert territory2;
        Test.startTest();
        Database.DeleteResult deleteResult = Database.delete(root, false);
        Test.stopTest();
        System.assertEquals(deleteResult.isSuccess(), false);
    }

    @IsTest static void testDeleteHasAccountsFail() {
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Account account = new Account(Name='Account1', Territory__c = root.Id);
        insert account;
        Test.startTest();
        Database.DeleteResult deleteResult = Database.delete(root, false);
        Test.stopTest();
        System.assertEquals(deleteResult.isSuccess(), false);
    }

    @IsTest static void testDeleteHasAccountsSuccess() {
        Territory__c root = new Territory__c(Name='Root');
        insert root;
        Test.startTest();
        Database.DeleteResult deleteResult = Database.delete(root, false);
        Test.stopTest();
        System.assertEquals(deleteResult.isSuccess(), true);
    }
}