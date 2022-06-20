/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class ContactShareRepository {

    public static List<ContactShare> getContactShare(Set<Id> contactIds, Id userOrGroupId, String rowCause) {
        return [
                SELECT Id, ContactId, UserOrGroupId, RowCause
                FROM ContactShare
                WHERE ContactId IN :contactIds
                AND UserOrGroupId = :userOrGroupId
                AND RowCause = :rowCause
        ];
    }

}