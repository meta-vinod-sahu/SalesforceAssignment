trigger TriggerAssignment  on Class__c (after update, before delete) {

    /**
     * Question: Not Allow any class to delete if there are more than one Female students.
     */
    if(Trigger.isDelete)
    {
        for(Id classId: Trigger.OldMap.keySet())
        {
            List<Student__c> resultList = [SELECT Class__c FROM Student__c 
            WHERE Sex__c = 'Female' AND Class__c = : classId   
            GROUP BY Class__c HAVING COUNT(Id)>1];
        
            for(Student__c result: resultList)
            {
                Trigger.OldMap.get(classId)  
                    .addError('You are not allowed to delete this class because of more then 1 female students.');
            } 
        }
    }

	/**
     * Question: Create a new picklist "Custom Status" in class Object 
     * (New, Open, Close, Reset) values. When this field changed & value 
     * is "Reset" now then delete all associated students with related class.
     */
    if(Trigger.isUpdate)
    {
        final String STATUS_RESET = 'Reset';
        
        Map<Id, Class__c> oldClassesMap = Trigger.OldMap;
        Map<Id, Class__c> newClassesMap = Trigger.NewMap;
        
        String oldCustomStatusName = null;
        String newCustomStatusName = null;
        
        Set<Id> classIdsToReset = new Set<Id>();
        Set<Id> studentIds = new Set<Id>();
        
        for(Class__c classinfo: Trigger.New)
        {
            oldCustomStatusName = oldClassesMap.get(classinfo.id).Custom_Status__c;
            newCustomStatusName = newClassesMap.get(classinfo.id).Custom_Status__c;
            
            if(oldCustomStatusName!= STATUS_RESET && newCustomStatusName == STATUS_RESET)
            {
                classIdsToReset.add(classinfo.id);
            }
        }
        
        List<Student__c> studentListToDelete = [SELECT Id FROM Student__c WHERE class__c in :classIdsToReset];
        delete studentListToDelete;
    }
}