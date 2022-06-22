/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class PermissionServiceTest {
    private static PermissionService service = PermissionService.getInstance();

    @IsTest static void testGetAccountShares() {
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Account account1 = new Account(Name='Account1');
        Account account2 = new Account(Name='Account2');
        Account account3 = new Account(Name='Account3');
        insert new List<Account> {account1, account2, account3};

        List<AccountShare> accountShares = service.getAccountShares(
                new Set<Id> {account1.Id, account3.Id},
                salesUser.Id,
                Constants.ACCESS_LEVEL_EDIT,
                Constants.ROW_CAUSE_MANUAL,
                Constants.ACCESS_LEVEL_NONE,
                Constants.ACCESS_LEVEL_NONE,
                Constants.ACCESS_LEVEL_NONE
        );

        System.assertEquals(accountShares.size(), 2);
    }

    @IsTest static void testGetContactShares() {
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Contact contact1 = new Contact(LastName='LastName1');
        Contact contact2 = new Contact(LastName='LastName2');
        insert new List<Contact> {contact1, contact2};
        List<ContactShare> contactShares = service.getContactShares(
                new Set<Id> {contact1.Id, contact2.Id},
                salesUser.Id,
                Constants.ACCESS_LEVEL_EDIT,
                Constants.ROW_CAUSE_MANUAL
        );
        System.assertEquals(contactShares.size(), 2);
    }

    @IsTest static void testGetAccountIdsWithoutPermissions() {
            User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
            Account account1 = new Account(Name='Account1');
            Account account2 = new Account(Name='Account2');
            Account account3 = new Account(Name='Account3');
            insert new List<Account> {account1, account2, account3};

            AccountShare accountShare1 = new AccountShare(
                    AccountId = account1.Id,
                    UserOrGroupId = salesUser.Id,
                    RowCause = Constants.ROW_CAUSE_MANUAL,
                    AccountAccessLevel = Constants.ACCESS_LEVEL_EDIT,
                    OpportunityAccessLevel = Constants.ACCESS_LEVEL_NONE,
                    CaseAccessLevel = Constants.ACCESS_LEVEL_NONE,
                    ContactAccessLevel = Constants.ACCESS_LEVEL_NONE
            );

            insert accountShare1;

            Set<Id> accounts = service.getAccountIdsWithoutPermissions(
                    new Set<Id>{account1.Id, account2.Id, account3.Id},
                    salesUser.Id,
                    Constants.ROW_CAUSE_MANUAL
            );
            System.assertEquals(accounts.size(), 2);
            System.assertEquals(accounts, new Set<Id>{account2.Id, account3.Id});
    }

    @IsTest static void testGetContactIdsWithoutPermissions() {
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Contact contact1 = new Contact(LastName='LastName1');
        Contact contact2 = new Contact(LastName='LastName2');
        Contact contact3 = new Contact(LastName='LastName3');
        insert new List<Contact> {contact1, contact2, contact3};

        ContactShare contactShare1 = new ContactShare(
                ContactId = contact1.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                ContactAccessLevel = Constants.ACCESS_LEVEL_EDIT
        );
        insert contactShare1;

         Set<Id> contactIds = service.getContactIdsWithoutPermissions(
                new Set<Id> {contact1.Id, contact2.Id, contact3.Id},
                salesUser.Id,
                Constants.ROW_CAUSE_MANUAL
        );

        System.assertEquals(contactIds.size(), 2);
        System.assertEquals(contactIds, new Set<Id> {contact2.Id, contact3.Id});

    }

    @IsTest static void testRemoveAccountPermissions() {
        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];
        Account account1 = new Account(Name='Account1');
        Account account2 = new Account(Name='Account2');
        insert account1;
        insert account2;

        AccountShare accountShare1 = new AccountShare(
                AccountId = account1.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                AccountAccessLevel = Constants.ACCESS_LEVEL_EDIT,
                OpportunityAccessLevel = Constants.ACCESS_LEVEL_NONE,
                CaseAccessLevel = Constants.ACCESS_LEVEL_NONE,
                ContactAccessLevel = Constants.ACCESS_LEVEL_NONE
        );
        AccountShare accountShare2 = new AccountShare(
                AccountId = account2.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                AccountAccessLevel = Constants.ACCESS_LEVEL_EDIT,
                OpportunityAccessLevel = Constants.ACCESS_LEVEL_NONE,
                CaseAccessLevel = Constants.ACCESS_LEVEL_NONE,
                ContactAccessLevel = Constants.ACCESS_LEVEL_NONE
        );
        insert accountShare1;
        insert accountShare2;

        service.removeAccountPermissions(new Set<Id> {account1.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);

        List<AccountShare> shares = [SELECT Id FROM AccountShare WHERE UserOrGroupId=:salesUser.Id AND RowCause=:Constants.ROW_CAUSE_MANUAL];
        System.assertEquals(shares.size(), 1);
        System.assertEquals(shares.get(0).Id, accountShare2.Id);
    }

    @IsTest static void testRemoveContactPermissions() {
        Contact contact1 = new Contact(LastName='LastName1');
        Contact contact2 = new Contact(LastName='LastName2');
        insert new List<Contact> {contact1, contact2};

        User salesUser = [SELECT Id FROM User WHERE Username='salesrep@oleksandrbielienovcorp.coma' LIMIT 1];

        ContactShare contactShare1 = new ContactShare(
                ContactId = contact1.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                ContactAccessLevel = Constants.ACCESS_LEVEL_EDIT
        );
        ContactShare contactShare2 = new ContactShare(
                ContactId = contact2.Id,
                UserOrGroupId = salesUser.Id,
                RowCause = Constants.ROW_CAUSE_MANUAL,
                ContactAccessLevel = Constants.ACCESS_LEVEL_EDIT
        );
        insert new List<ContactShare>{contactShare1, contactShare2};

        service.removeContactPermissions(new Set<Id>{contact1.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);
        List<ContactShare> shares = [SELECT Id FROM ContactShare WHERE UserOrGroupId=:salesUser.Id AND RowCause=:Constants.ROW_CAUSE_MANUAL];
        System.assertEquals(shares.size(), 1);
        System.assertEquals(shares.get(0).Id, contactShare2.Id);
    }
}