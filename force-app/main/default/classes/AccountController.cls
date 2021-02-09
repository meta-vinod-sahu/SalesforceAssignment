public class AccountController {
    
    public Integer noOfRecords{get;set;} 
    private String city{get;set;}
    private String state{get;set;}
    private String country{get;set;}
    public String query;
    public Integer resultSize{get;set;}
    public AccountController() {
        noOfRecords = 10;
    }
    
    public String getCity(){
        return this.city ;
    }
    public void setCity(String city){
        this.city = city;
    }
    public String getState(){
        return this.state ;
    }
    public void setState(String state){
        this.state = state ;
    }
    public String getCountry(){
        return this.country ;
    }
    public void setCountry(String country){
        this.country = country ;
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) { 
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                setCon.setPageSize(noOfRecords);  
            }            
            return setCon;
        }
        set;
    }
    
    public void searchAccounts(){
        setCon = null;
    }
    
    public List<Account> getAccounts() {
        query = 'select Name , BillingCity , BillingState ,BillingCountry FROM Account ';
        if(!String.isBlank(city) || !String.isBlank(state) || !String.isBlank(country)) {
            query+='WHERE' ;
            query+=String.isBlank(city)?'':' BillingCity LIKE '+'\'%'+city+'%\''+' AND ';
            query+=String.isBlank(state)?'':' BillingState LIKE '+'\'%'+state+'%\''+' AND ';
            query+=String.isBlank(country)?'':' BillingCountry LIKE '+'\'%'+country+'%\'';
        }
        if(query.endsWith('AND ')) {
            query = query.substring(0, query.length()-4);
        }
        city = null;
        state = null;
        country = null;
        resultSize = setCon.getResultSize();
        return (List<Account>) setCon.getRecords();
    }
    

}