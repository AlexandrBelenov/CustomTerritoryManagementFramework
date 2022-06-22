/**
 * Created by alexanderbelenov on 22.06.2022.
 */

public class StaticTest{
    public static Boolean doNotRunTrigger = false;

    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }

    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
}