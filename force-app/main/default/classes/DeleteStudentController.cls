public class DeleteStudentController {
    
    public String BaseUrl{get;set;}
    public boolean Render{get;set;}
    
    public DeleteStudentController(ApexPages.StandardSetController controller) {
        String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
        String[] instance = urlInstance.split('\\.');
        BaseUrl = instance[1];
        if(controller.getSelected().size() == 0) {
            Render = false;
        }else {
            Render = true;
        }
    }
    
}