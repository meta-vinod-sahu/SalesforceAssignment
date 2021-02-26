trigger Students on Student__c (after insert, after update) {
    
    Map<Id, Integer> classToNumberOfStudentsMap= new Map<Id, Integer>();
    
    /**
     * Question: Not allow insert student if class already 
     reached MaxLimit.(Without using MyConnt field).
     */
    if(Trigger.isInsert)
     {
        Set<Id> classIdsList = new Set<Id>();
         
        Integer totalNumberOfStudentsInClass = 0;
        Class__c classInfo = null;
    
        for(Student__c student: Trigger.New)
        {
            classIdsList.add(student.class__c);
        }
    
        Map<Id,Class__c> classInfoMap = new Map<Id,Class__c>([SELECT Id, Number_Of_Students__c, 
        MaxSize__c FROM Class__c WHERE Id IN :classIdsList]);
    
        for(Student__c student: Trigger.new)
        {    
            classInfo = classInfoMap.get(student.class__c);
    
            if(!classToNumberOfStudentsMap.containsKey(student.class__c))
            {
                totalNumberOfStudentsInClass = (Integer)classInfo.Number_Of_Students__c;
            }
            else {
                totalNumberOfStudentsInClass = classToNumberOfStudentsMap.get(student.class__c);     
            }
            
            if(totalNumberOfStudentsInClass >= (Integer)classInfo.MaxSize__c )
            {
                student.addError('Class full');
            }
            else {
                updateNumberOfStudentsInClass(student.class__c);
            }
        }
         
     }
    
    private void updateNumberOfStudentsInClass(Id classId){
        if(!classToNumberOfStudentsMap.containsKey(classId))
        {
            classToNumberOfStudentsMap.put(classId, 0);            
        }
        else {
            classToNumberOfStudentsMap.put(classId, (classToNumberOfStudentsMap.get(classId) + 1));
        }
    }

    /**
     * Question: When insert/update any student’s in class then update MyCount Accordingly(Use MyCount as a number field).
     */

    Set<Id> classIdSet = New Set<Id>();
    
    For(Student__c student: Trigger.new)
    {
        classIdSet.add(student.class__c);
    }

    List<AggregateResult> aggregateResultList =  [SELECT COUNT(Class__r.Id) classCount, 
    class__c FROM Student__c where class__c IN :classIdSet GROUP BY Class__c];  

    Map<Id, Integer> classIdAndCountMap = new Map<Id, Integer>();

    for(AggregateResult result: aggregateResultList)    
    {
        classIdAndCountMap.put((Id)result.get('class__c'),
         (Integer)result.get('classCount'));
    } 

    Map<Id, Class__c> classMap = new Map<Id, Class__c>(
        [SELECT id, myCount__c FROM Class__c WHERE id IN :classIdSet]);

    List<Class__c> classToUpdate = new List<Class__c>();

    for(Class__c classInfo: classMap.values())
    {
        classInfo.myCount__c =  classIdAndCountMap.get(classInfo.id);
        classToUpdate.add(classInfo);
    }    

    update classToUpdate;
}
