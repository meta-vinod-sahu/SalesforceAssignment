public class AccountSearchWithPaginationController {


    public integer currentPageNumber {get;set;}   
    public integer totalNumberOfPages {get;set;}   
    public integer recordsPerPage {get;set;} 
    public integer numberOfRecords{get;set;} 
    public integer offset{get;set;}

    public  String billingCity {get;set;}
    public  String billingState {get;set;}
    public  String billingCountry {get;set;}
    public List<SObject> accountList {get;set;}
    public String billingCitySearchString {get; set;}
    public String billingStateSearchString {get; set;}
    public String billingCountrySearchString {get; set;}
    public String selectAccountQuery {get; set;}
    public String countAccountQuery {get; set;}
    public String queryPostFix {get; set;}

    public AccountSearchWithPaginationController(ApexPages.StandardController controller) {
        this.recordsPerPage = 10;  
        this.currentPageNumber = 1;
        this.totalNumberOfPages = 1; 
        this.accountList = null;
        this.beginning();
    }
    
    // update method name as per context
   public void beginning(){
       this.initialize();
       currentPageNumber=1;
       search();
   }
   
    public void previous(){
        if(currentPageNumber >= 2){
            currentPageNumber-=1;
            search(); 
        }
        
    }
    
    public void next(){
        if(currentPageNumber < totalNumberOfPages){
            currentPageNumber += 1;
            search();
        } 
    }
    
    public void last(){
        currentPageNumber = totalNumberOfPages;
        search();
    } 
    
    public void first(){
        currentPageNumber = 1;
        search();
    } 
    
    
    public void initialize(){
       
       // use dynamic query instead
        this.currentPageNumber = 1;
        this.offset = 0;
        
        this.selectAccountQuery = 'SELECT id, Name, billingCity, billingState, billingCountry FROM Account';
        this.countAccountQuery = 'SELECT count() FROM Account';
        this.queryPostFix = '';
                                    
        if(this.billingCity != '')
        {
           queryPostFix = ' WHERE billingCity LIKE ' +  ('\'%' + this.billingCity + '%\'');
        }
        if (this.billingState != '')
        {
            if(this.billingCity == '')
            {
             this.billingStateSearchString = ' WHERE billingState LIKE ' +  ('\'%' + this.billingState + '%\'');
            }
            else {
                this.billingStateSearchString = ' AND billingState LIKE ' +  ('\'%' + this.billingState + '%\'');
            }
            queryPostFix = queryPostFix + this.billingStateSearchString; 
        }
        if(this.billingCountry != '')
        {
            if(this.billingCity == '' && this.billingState == '')
            {
                this.billingCountrySearchString = ' WHERE billingCountry LIKE ' +  ('\'%' + this.billingCountry + '%\'');
            }else {
                this.billingCountrySearchString = ' AND billingCountry LIKE ' +  ('\'%' + this.billingCountry + '%\'');
            }
            
            queryPostFix = queryPostFix + this.billingCountrySearchString; 
        }
        
     
        this.offset = (this.currentPageNumber-1)*this.recordsPerPage;
        
        System.debug('.........' + (selectAccountQuery + queryPostFix + ' LIMIT ' + this.recordsPerPage  + ' OFFSET '+ this.offset));
        

        this.accountList = Database.query(selectAccountQuery + queryPostFix + ' LIMIT ' + this.recordsPerPage  + ' OFFSET '+ this.offset);
            
        this.numberOfRecords = Database.countQuery(countAccountQuery + queryPostFix);
        
        
        this.totalNumberOfPages = (Integer)Math.ceil((Decimal)this.numberOfRecords/(Decimal)this.recordsPerPage);  
        
        System.debug('.........accountList ' + (accountList));
        System.debug('.........numberOfRecords ' + (numberOfRecords));
        System.debug('.........totalNumberOfPages ' + (totalNumberOfPages));

        
        
    } 
    
    
   private void search(){            
            this.offset = (this.currentPageNumber-1)*this.recordsPerPage;               
            this.accountList = Database.Query(
            this.selectAccountQuery + this.queryPostFix + ' LIMIT ' + this.recordsPerPage  + ' OFFSET '+ this.offset);
         }   
         
               
    public Boolean getIsAccountListEmpty(){
        if(this.accountList == null || this.accountList.size()==0) 
        {
            return false;
        }
        return true;
    }
   
}