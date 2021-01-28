public class AccountHandler {
    public Static Account insertNewAccount(String AccountName)
    {
        if(AccountName.length()>=1){
            try{
            Account acc = new Account();
            acc.Name = AccountName;
            acc.AccountNumber =  '00000000';
            insert acc;
            system.debug(acc); 
            return acc;
            }catch (DMLException e)
            {          
             system.debug('Failed due to  '+e.getMessage());   
             return null;              
            }
           
        }
        else {
                return null;      
               }
        
    }
        
}