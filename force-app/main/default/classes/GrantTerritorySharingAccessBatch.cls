/**
 * Created by alexanderbelenov on 17.06.2022.
 */

public with sharing class GrantTerritorySharingAccessBatch implements Database.Batchable<sObject> {

    public void execute(Database.BatchableContext param1, List<sObject> param2) {
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Iterable<sObject> start(Database.BatchableContext param1) {
        return null;
    }
}