/**
 * Created by alexanderbelenov on 21.06.2022.
 */

trigger TerrUserTrigger on TerrUser__c (before insert, before update,
        before delete, after insert, after update, after delete, after undelete) {
    TerrUserTriggerHandler handler = TerrUserTriggerHandler.getInstance();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.afterInsert(Trigger.newMap);
        } else if (Trigger.isDelete) {
            handler.afterDelete(Trigger.oldMap);
        }
    }

}