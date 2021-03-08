public class QueryResultController {
    
    public String queryToExecute;
    public String finalQuery ;
    public List<string> LstFields{get;private set;}
    public Integer StartingPageRecord{get;set;}
    public Integer EndingPageRecord{get;set;}
    public String FieldName{get;set;}
    public boolean RenderMessage{get;set;}
    
    public QueryResultController() {
        queryToExecute = '';
        finalQuery = '';
        setCon = null ;
        RenderMessage = false;
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                try {
                    setCon = new ApexPages.StandardSetController(Database.query(finalQuery));
                    setCon.setPageSize(5);
                }catch(QueryException ex) {
                    ApexPages.addMessages(ex);
                    RenderMessage = true;
                }
            }
            return setCon;
        }
        set;
    }
    
    public String getqueryToExecute() {
        return this.queryToExecute;
    }
    
    public void setqueryToExecute(String QueryString) {
        if(!this.queryToExecute.equalsIgnoreCase(QueryString)) {
            this.queryToExecute = QueryString;
            this.setCon = null;
            finalQuery = queryToExecute;
            RenderMessage = false;
        } 
    }
    
    public List<Sobject> getRecordType() {
        List<Sobject> QueryResult;
        try{
            QueryResult = setCon.getRecords();
        }catch(Exception ex){
            return null;
        }
        startingPageRecord = setCon.getPageNumber() * setCon.getPageSize() - (setCon.getPageSize() - 1);
        EndingPageRecord = setCon.getPageNumber() * setCon.getPageSize() ;
        Set<string> setFields = new Set<String>();
        for(integer i = 0 ; i < QueryResult.size() ; i++){
            setFields.addAll(QueryResult[i].getPopulatedFieldsAsMap().keySet());
        }
        LstFields = new List<String>();
        LstFields.addAll(setFields); 
        return QueryResult;
    }
    
    public void sortData() {
        
        if(finalQuery.containsIgnoreCase('ORDER BY')) {
            finalQuery = finalQuery.substring(0, finalQuery.indexOfIgnoreCase('order by') - 1);
        }
        finalQuery = finalQuery + ' ORDER BY ' + this.FieldName;  
        setCon = null;
    }
    
}