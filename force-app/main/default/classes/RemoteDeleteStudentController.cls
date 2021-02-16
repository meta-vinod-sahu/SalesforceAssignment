public with sharing class RemoteDeleteStudentController {
    
    public String BaseUrl{get;set;}
    public boolean Render{get;set;}
    
    public RemoteDeleteStudentController(ApexPages.StandardSetController controller) {
        String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
        String[] instance = urlInstance.split('\\.');
        BaseUrl = instance[1];
        if(controller.getSelected().size() == 0) {
            Render = false;
        }else {
            Render = true;
        }
    }
    
    @RemoteAction
    public static Database.DeleteResult[] deleteStudents(List<ID> students) {
        Database.DeleteResult[] result;
        try {
            result = Database.delete(students);
        }catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        return result;
    }
}