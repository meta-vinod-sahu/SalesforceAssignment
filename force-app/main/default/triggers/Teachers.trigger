trigger Teachers on Contact (after insert, after update) {
    /**
     * Question: Not Allow any teacher to insert/update if 
     that teacher is teaching Hindi (Use subject multi select picklist).
     */
    
    List<String> Subjects = null; 
    Map<Id, Contact> oldTeacherMap = Trigger.OldMap; 
    Map<Id, Contact> newTeacherMap = Trigger.NewMap; 
    
    
    List<Contact> teacherList = Trigger.New;
    
    for(Contact teacher: teacherList)
    {
        validateTeacher(teacher.id);
    }

    private static void validateTeacher(Id teacherId){
        boolean allowUpdate = true;
        Contact teacher = newTeacherMap.get(teacherId);
       	Subjects = getListOfSelectedItemsFromSelectedItemsString(teacher.Subjects__c);
	    if(Subjects.contains('Hindi'))
        {
            allowUpdate = false;
        }
        else if(Trigger.isUpdate)
        {
        	Subjects = Utility.getListOfSelectedItemsFromSelectedItemsString(
                oldTeacherMap.get(teacherId).Subjects__c);
            allowUpdate = Subjects.contains('Hindi')?false: true;
        }        
        if(!allowUpdate)
        {
         teacher.Subjects__c.addError('Teacher Teaching Hindi Cannot be Inserted or Updated');
        }
    }
    
    public static List<String> getListOfSelectedItemsFromSelectedItemsString(String pickListItems){
	    return pickListItems.split(';');
    }
}
