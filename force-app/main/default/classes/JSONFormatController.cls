public class JSONFormatController {
  private final Student__c std;
    public String JSONObjectString{get;set;}
    
    public JSONFormatController(ApexPages.StandardController stdController){
        this.std = (Student__c)stdController.getRecord(); 
    }
    
    public void serailize() {
        Student__c StudentToConvert = [SELECT Id, Name , Sex__c , DOB__c FROM Student__c WHERE ID = :std.Id];
        JSONObjectString = JSON.serialize(StudentToConvert);
    }
}