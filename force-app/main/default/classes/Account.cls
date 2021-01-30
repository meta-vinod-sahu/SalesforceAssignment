/**
* Question: Create One Custom field in Account Object 'ContactId',
* it would have comma seprated list of all related contact Ids. 
* Create a Class & a static function which takes a ContactId as argument
* and check if Account's ContactId field is null or not
*   - If Null, then fetch all related account contacts and store their 
*   Ids as a comma seprated list in it
*   - If Not, then check, Is ContactId already exist in field value
*   otherwise append in string
*/
public class Account{
    
    public static String addContactIdToAccount(String contactId){
        Account account = [SELECT Id, Name, ContactId__c From Account WHERE Id IN 
                           (SELECT AccountId From Contact Where Id = :contactId)];
        if(account.ContactID__c == null){
            return addContactIds(account.Id);
        }
        return updateContactId(account.ContactID__c, contactId);
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
