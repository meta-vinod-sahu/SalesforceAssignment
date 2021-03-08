public class Utility {
    public static List<String> getNameOfStudents(List<Student__c> students){
        List<String> studentNames = new List<String>();
        for(Student__c student: students){
            studentNames.add(student.Name);
        }
        return studentNames;
    }
    
    public static String getContactIdAsString(List<Contact> contacts){
        Boolean isFirst = true;
        String contactIds;
        for(Contact contact: contacts){
            if(isFirst){
            	contactIds = contact.Id;
                isFirst = false;
            }else{
                contactIds += ','+contact.Id;
            }
        }
        return contactIds;
    }
    
}