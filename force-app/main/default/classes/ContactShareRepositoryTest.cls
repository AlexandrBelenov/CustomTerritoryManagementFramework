/**
 * Created by alexanderbelenov on 22.06.2022.
 */

@IsTest
private class ContactShareRepositoryTest {
    @IsTest static void testGetContactShare() {
        User user = [SELECT Id FROM User WHERE Username='oleksandr.bielienov@oleksandrbielienovcorp.coma' LIMIT 1];
        System.runAs(user){
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

            List<ContactShare> shares = ContactShareRepository.getContactShare(new Set<Id>{contact1.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);

            System.assertEquals(shares.size(), 1);
            System.assertEquals(shares.get(0).Id, contactShare1.Id);

            List<ContactShare> shares2 = ContactShareRepository.getContactShare(new Set<Id>{contact1.Id, contact2.Id}, salesUser.Id, Constants.ROW_CAUSE_MANUAL);
            System.assertEquals(shares2.size(), 2);
        }
    }
}