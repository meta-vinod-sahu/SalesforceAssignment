public class CustomLookUpController {
    
    public String SelectedContact = null;
    public Id CurrentOpportunityId{get;set;}
    public Opportunity CurrentOpportunity{get;set;}
    
    public CustomLookUpController() {
        CurrentOpportunityId = ApexPages.currentpage().getparameters().get('id');
        CurrentOpportunity = [SELECT Id , Name , BillToContact__c , Manager__c FROM Opportunity WHERE Id = :CurrentOpportunityId];
    }
    
    public list<SelectOption> getContactOptions() {
        List<Contact> ContactObjects = [SELECT name FROM Contact WHERE AccountId = :CurrentOpportunity.Manager__c ];
        list<SelectOption> options = new list<SelectOption>();
        for(Contact con : ContactObjects){
            options.add(new SelectOption(con.Id,con.Name));
        }
        return options;
    }
    
    public String getSelectedContact() {
        return SelectedContact;
    }
    
    public void setSelectedContact(String SelectedContact) {
        this.SelectedContact = SelectedContact;
    }
    
    public PageReference saveContact() {
        CurrentOpportunity.BillToContact__c = SelectedContact ;
        update CurrentOpportunity;
        return new PageReference('/'+CurrentOpportunityId);
    }
    public PageReference clearContact() {
        CurrentOpportunity.BillToContact__c = null ;
        update CurrentOpportunity;
        return new PageReference('/'+CurrentOpportunityId);
    }
    public PageReference cancel() {
        return new PageReference('/'+CurrentOpportunityId);
    }
}