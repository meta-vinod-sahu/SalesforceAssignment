global class SendEmailToOpptyOwner implements Database.Batchable<SObject> {

   /**
     * Question: Create a schedular to mail an opportunity owner if not modified last 30 days
     */

    global Database.QueryLocator start(Database.BatchableContext Bc){
        return Database.getQueryLocator([Select Id,ownerID from Opportunity where LastModifiedDate = LAST_N_DAYS:30]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity > scope){
     for(Opportunity s : scope){
       EmailManager em = new EmailManager();
         em.sendMail('vinod.sahu@metacube.com', 'Notify for modification','Please modify');
     }
   }
    global void finish(Database.BatchableContext Bc){

    }
}