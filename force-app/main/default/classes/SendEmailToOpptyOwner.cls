global class SendEmailToOpptyOwner implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext Bc){
        return Database.getQueryLocator([Select Id,ownerID from Opportunity where LastModifiedDate = LAST_N_DAYS:30]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity > scope){
     for(Opportunity s : scope){
       EmailSendManager em = new EmailSendManager();
         em.sendMail(s.email__c, 'Notify for modification','Please modify');
     }
   }
    global void finish(Database.BatchableContext Bc){

    }
}
