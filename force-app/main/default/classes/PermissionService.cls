/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class PermissionService {

    private PermissionService() {}

    public List<AccountShare> getAccountShares(Set<Id> accountIds, Id userOrGroupId, String accessLevel, String rowCause,
            String opportunityAccessLevel, String caseAccessLevel, String contactAccessLevel) {
        final List<AccountShare> newAccountShares = new List<AccountShare>();
        for (Id accountId :accountIds) {
            final AccountShare thisAccountShare = new AccountShare(
                    AccountId = accountId,
                    UserOrGroupId = userOrGroupId,
                    AccountAccessLevel = accessLevel,
                    RowCause = rowCause,
                    OpportunityAccessLevel = opportunityAccessLevel,
                    CaseAccessLevel = caseAccessLevel,
                    ContactAccessLevel = contactAccessLevel
            );
            newAccountShares.add(thisAccountShare);
        }
        return newAccountShares;
    }

    public List<ContactShare> getContactShares(Set<Id> contactIds, Id userOrGroupId, String accessLevel, String rowCause) {
        final List<ContactShare> newContactShares = new List<ContactShare>();
        for (Id contactId : contactIds) {
            ContactShare thisContactShare = new ContactShare(
                    ContactId = contactId,
                    userOrGroupId = userOrGroupId,
                    ContactAccessLevel = accessLevel,
                    RowCause = rowCause
            );
            newContactShares.add(thisContactShare);
        }
        return newContactShares;
    }

    public Set<Id> getAccountIdsWithoutPermissions(Set<Id> accountIds, Id userOrGroupId, String rowCause) {
        final List<AccountShare> existedPermissions = AccountShareRepository.getAccountShare(accountIds, userOrGroupId, rowCause);
        final Set<Id> accountsIdWithoutPermission = new Set<Id>();
        for (Id accountId : accountIds) {
            Boolean isExists = false;
            for (AccountShare permission : existedPermissions) {
                if (permission.AccountId == accountId
                        && permission.UserOrGroupId == userOrGroupId
                        && permission.RowCause == rowCause) {
                    isExists = true;
                    break;
                }
            }
            if (isExists == false) {
                accountsIdWithoutPermission.add(accountId);
            }
        }
        return accountsIdWithoutPermission;
    }

    public Set<Id> getContactIdsWithoutPermissions(Set<Id> contactIds, Id userOrGroupId, String rowCause) {
        final List<ContactShare> existedPermissions = ContactShareRepository.getContactShare(contactIds, userOrGroupId, rowCause);
        final Set<Id> contactsIdWithoutPermission = new Set<Id>();
        for (Id contactId : contactIds) {
            Boolean isExists = false;
            for (ContactShare permission : existedPermissions) {
                if (permission.ContactId == contactId
                        && permission.UserOrGroupId == userOrGroupId
                        && permission.RowCause == rowCause) {
                    isExists = true;
                    break;
                }
            }
            if (isExists == false) {
                contactsIdWithoutPermission.add(contactId);
            }
        }
        return contactsIdWithoutPermission;
    }

    private static PermissionService instance;
    public static PermissionService getInstance() {
        if (instance == null) {
            instance = new PermissionService();
        }
        return instance;
    }

}