public  class populateContactIdsOnAccount {
    /**
     * Create a class of BillToContact manager
     */
    public static void populateContactIdsOnAccount(List<Contact> listOfNewContacts, Map<Id, Contact> mapOfOldContacts) {
        Set<Id> accountIds = new Set<Id>();
        if(Trigger.isInsert || Trigger.isUndelete) {
            for(Contact con : listOfNewContacts){
                accountIds.add(con.AccountId);
                System.debug('Contact ids' + con.AccountId);
            }
        }
        
        if(Trigger.isDelete) {
            System.debug('Delete Undelete');
            for(Contact con : mapOfOldContacts.values()) {
                accountIds.add(con.AccountId);
                System.debug('Contact ids' + con.AccountId);
            }
        }
        if(Trigger.isUpdate) {
            for(Contact con : listOfNewContacts) {
                if(con.AccountId != mapOfOldContacts.get(con.Id).AccountId) {
                    accountIds.add(con.AccountId);
                    accountIds.add(mapOfOldContacts.get(con.Id).AccountId);
                }
            }
        }
        List<Account> listOfAccountToUpdate = new List<Account>();
        for(Account acc : [Select id , ContactIDs__c,(Select id, AccountId From Contacts) From Account Where Id IN : accountIds]) {
            Account accountToUpdate = new Account();
            accountToUpdate.id = acc.id;
            accountToUpdate.ContactIDs__c = '';
            String comma = '';
            for(Contact con : acc.Contacts){
                accountToUpdate.ContactIDs__c = accountToUpdate.ContactIDs__c+ comma +con.Id;
                comma = ',';
            }
            listOfAccountToUpdate.add(accountToUpdate);
        }
        if(!listOfAccountToUpdate.isEmpty()) {
            update listOfAccountToUpdate;
        }
    }
}
