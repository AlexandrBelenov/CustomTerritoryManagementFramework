trigger TerritoryTrigger on Territory__c (before insert, before update,
        before delete, after insert, after update, after delete, after undelete) {

    final TerritoryTriggerHandler handler = TerritoryTriggerHandler.getInstance();
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
    } else if (Trigger.isBefore && Trigger.isDelete) {
        handler.beforeDelete(Trigger.oldMap);
    }
}