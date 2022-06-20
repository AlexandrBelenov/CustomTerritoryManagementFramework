/**
 * Created by alexanderbelenov on 20.06.2022.
 */

public with sharing class TerritoryComparator extends Comparator {

    public override Integer compare(Object o1, Object o2) {
        return ((Territory__c)o1).name.compareTo(((Territory__c)o2).name);
    }
}