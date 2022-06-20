/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class AccountShareRepository {
    public static List<AccountShare> getAccountShare(Set<Id> accountIds, Id userOrGroupId, String rowCause) {
        return [
                SELECT Id, AccountId, UserOrGroupId, RowCause
                FROM AccountShare
                WHERE AccountId IN :accountIds
                AND UserOrGroupId = :userOrGroupId
                AND RowCause = :rowCause
        ];
    }
}