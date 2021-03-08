public class MyController {

    private final Class__c classDetail;

    public MyController() {
        classDetail = [SELECT Id, Name FROM Class__c ];
    }

    public Class__c getClasses() {
        return classDetail;
    }

   
}