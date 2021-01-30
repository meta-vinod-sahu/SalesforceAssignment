trigger AccountAddressTrigger on Account (before insert, before update) {
    List<Account> acct = new List <Account>();
    for(Account a: Trigger.new){
        if( a.Match_Billing_Address__c == true && a.BillingPostalCode!=null ){
            a.ShippingPostalCode = a.BillingPostalCode;
        }
    }

}