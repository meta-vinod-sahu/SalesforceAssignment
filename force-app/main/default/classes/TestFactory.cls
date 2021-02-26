public class TestFactory {
 
    public static List<Class__c> createClassAndRespectiveStudents(Integer numberOfClass, Integer numberOfStudents){
        List<Class__c> classes = new List<Class__c>();
        Contact teacher = new Contact(FirstName = 'Test', LastName = 'Teacher');
        for(Integer i = 1; i<=numberOfClass; i++){
            Class__c currentClass = new Class__c(Name='Class '+i, Board__c = 'Raj',
                                                Fee__c = 12000, maxSize__C = i*35, 
                                                 ClassTeachers__c = teacher.Id);
            classes.add(currentClass);
        }
        insert classes;
        List<Student__c> students = new List<Student__c>();
        for(Integer i = 1; i<=numberOfClass; i++){
            for(Integer j =1; j<=numberOfStudents; j++){
                Student__c student = new Student__c(Name=classes.get(i-1).Name+' Test '+j, LastName__c= 'Student',
                                                   Class__C = classes.get(i-1).Id, 
                                                    Email__C = 'test.student'+j+'@mail.com');
                students.add(student);
            }
        }
        insert students;
        return classes;
    }
    
   public static void createContactAssociateWithAccount(){
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i=1; i<6; i++){
            Contact contact = new Contact(FirstName = 'Contact ', LastName='Test '+i);
            contacts.add(contact);
        }
        insert contacts;
    }
}