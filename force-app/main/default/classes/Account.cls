public class Account{
   
    public static String addContactIdToAccount(String contactId){
        List<SObject> accounts = [SELECT Id, Name, ContactId__c From Account WHERE Id IN 
                           (SELECT AccountId From Contact Where Id = :contactId)];

        for(SObject account:accounts){
        
               return addContactIds(account.id);
           
        }
           return updateContactId(accounts.get(0).Id, contactId);   
           
       
        
    }
   
    private static String addContactIds(String accountId){
        List<Contact> contacts = findContactByAccountId(accountId);
        Boolean isFirst = true;
        String contactIds;
        for(Contact contact: contacts){
            if(isFirst){
            	contactIds = contact.Id;
                isFirst = false;
            }else{
                contactIds += ','+contact.Id;
            }
        }
        return contactIds;
    }

    
    private static List<Contact> findContactByAccountId(String accountId){
        return [SELECT Id, Name From Contact Where AccountId = :accountId];
    }
    
    
    private static String updateContactId(String currentIds, String idToBeUpdate){
        if(currentIds.contains(idToBeUpdate)){
            return currentIds;
        }
        return currentIds+','+idToBeUpdate;
    }
}