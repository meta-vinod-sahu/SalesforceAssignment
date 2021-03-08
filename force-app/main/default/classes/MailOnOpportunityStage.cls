public class MailOnOpportunityStage {
    
    public static void sendEmail(List<Opportunity> opps) {
        Messaging.reserveSingleEmailCapacity(opps.size());
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate temp = (EmailTemplate)[select Id FROM EmailTemplate WHERE Name = 'OpportunityStage' limit 1];
        
        Map<Id,Contact> contactsMap = new Map<Id,Contact>();
        for(Integer index = 0 ; index < opps.size() ; index++) {
            contactsMap.put(opps[index].Id,new Contact(lastName = 'test'+index , email = opps[index].owner.email));
        }
        insert contactsMap.values() ;
        
        for(Id oppId : contactsMap.keySet()) {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setReplyTo('vinod.sahu@metacube.com') ;
            mail.setSenderDisplayName('Salesforce Support');
            mail.setUseSignature(false); 
            mail.setBccSender(false); 
            mail.setSaveAsActivity(false); 
            mail.setTemplateId(temp.Id);
            mail.setTargetObjectId(contactsMap.get(oppId).Id);
            mail.setWhatId(oppId);
            mails.add(mail);
        }
        try {
            Messaging.sendEmail(mails);
        } catch (Exception e) {
            System.debug(e.getMessage());
        } finally {
        	delete contactsMap.values() ;
        }
    }
}