trigger StageChangedTrigger on SOBJECT (before insert) {

    /**
     * Question: In Opportunity, If the stage is changed from 
     another value  to CLOSED_WON or CLOSED_LOST, populates the Close 
     Date field with Today().
     */
	Map<Id, Opportunity> oldOpportunitiesMap = Trigger.OldMap;
    Map<Id, Opportunity> newOpportunitiesMap = Trigger.NewMap;
    String oldStageName = null;
    String newStageName = null;
    for(Opportunity opp: Trigger.New)
    {
        oldStageName = oldOpportunitiesMap.get(opp.id).StageName;
        newStageName = newOpportunitiesMap.get(opp.id).StageName;
        if((oldStageName!='CLOSED WON' && oldStageName!='CLOSED LOST') 
            && (newStageName=='CLOSED WON' || newStageName=='CLOSED LOST'))
        {
            opp.CloseDate = Date.TODAY();
        }
    }
}