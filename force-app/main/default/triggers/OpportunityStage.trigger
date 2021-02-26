trigger OpportunityStage on Opportunity (after update) {
    
    List<opportunity> updatedOpps = new List<Opportunity>();
    List<opportunity> mailList = new List<Opportunity>();
    for(opportunity op : [SELECT Id , stageName ,ownerId, owner.email, CloseDate FROM Opportunity WHERE Id IN :Trigger.New ]){
        if(Trigger.oldMap.get(op.Id).StageName != op.StageName){
            if(op.StageName == 'Closed Won' || op.StageName == 'Closed Lost') {
                op.CloseDate = date.today();
                updatedOpps.add(op);
            }
            mailList.add(op);
        }
    }
    MailOnOpportunityStage.sendEmail(mailList);  
}