/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class Utility {
    public static Set<Id> getIds(List<SObject> items) {
        Set<Id> ids = new Set<Id>();
        for (SObject sobj : items) {
            ids.add(sobj.Id);
        }
        return Ids;
    }
}