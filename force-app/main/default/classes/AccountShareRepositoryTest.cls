/**
 * Created by alexanderbelenov on 22.06.2022.
 */
@IsTest
private class AccountShareRepositoryTest {

    @IsTest static void testGetAccountShare() {
        User user = [SELECT Id FROM User WHERE Username='oleksandr.bielienov@oleksandrbielienovcorp.coma' LIMIT 1];
        System.runAs(user) {
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

            List<AccountShare> returnedShares = AccountShareRepository.getAccountShare(new Set<Id>{account1.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);
            System.assertEquals(returnedShares.size(), 1);
            System.assertEquals(returnedShares.get(0).Id, accountShare1.Id);

            List<AccountShare> returnedSharesTwo = AccountShareRepository.getAccountShare(new Set<Id>{account1.Id, account2.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);
            System.assertEquals(returnedSharesTwo.size(), 2);
        }
    }
}