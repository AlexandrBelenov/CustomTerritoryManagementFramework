/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class UtilityTest {

    @IsTest static void testNull() {
        Set<Id> ids = Utility.getIds(null);
        Set<Id> result = new Set<Id>();
        System.assertEquals(ids, result);
    }

    @IsTest static void testZeroElements() {
        List<SObject> objList = new List<SObject>();
        Set<Id> ids = Utility.getIds(objList);
        Set<Id> result = new Set<Id>();
        System.assertEquals(ids, result);
    }

    @IsTest static void testOneElement() {
        Account account = new Account(Name='Test Account');
        insert account;

        List<SObject> objList = new List<SObject>();
        objList.add(account);

        Set<Id> result = new Set<Id>();
        result.add(account.Id);

        Set<Id> ids = Utility.getIds(objList);

        System.assertEquals(ids, result);
    }

    @IsTest static void testTwoElements() {
        Account account = new Account(Name='Test Account');
        Contact contact = new Contact(LastName='Test contact');
        insert account;
        insert contact;
        List<SObject> objList = new List<SObject>();
        objList.add(account);
        objList.add(contact);

        Set<Id> result = new Set<Id>();
        result.add(account.Id);
        result.add(contact.Id);

        Set<Id> ids = Utility.getIds(objList);

        System.assertEquals(ids, result);
    }
}