public class ApexAssignment
{
    /**
     * Question: Create A Class & a static Function which takes 
     * classId as argument and returns all names of student in that 
     * class as a list
     * classId: 
     * return
     * */
    public static List<String> getStudentNamesByClassId(Set<String> classId){
        List<Student__C> students = [Select Id, Name, Class__c From Student__C 
                                     WHERE Class__c in (SELECT ID From Class__c Where Id in  (:classId))];
        List<String> studentNames = new List<String>();
        for (Student__c student : students){
            studentNames.add(student.Name);
        }
        return studentNames;
    }
    
    /**
     * Question: Create a function which returns a map where 
     * key is class and value is set of StudentId in it
     * return map where key is class Id & Value Contains Set of StudentIds
     * enrolled in that class
     * */
    public static Map<Class__C,Set<Id>> getClassWiseMapOfStudents(){
        List<Class__C> classes = [Select Id, Name, (Select Id, Name From Students__r) From Class__c];
        Map<Class__C, Set<Id>> classWiseMapOfStudents = new Map<Class__C, Set<Id>>();
        for(Class__C currentClass: classes){
            String classId = currentClass.Id;
            List<Student__c> students = currentClass.students__r;
            Set<Id> studentIds = new Set<Id>(); 
            for(Student__c student: students){
                studentIds.add(student.Id);
            }
            classWiseMapOfStudents.put(currentClass, studentIds);
        }
        return classWiseMapOfStudents;
    }

    /**
     * Question: Create a function which takes two dates as argumets
     * and return number of working days between two dates and including 
     * both dates. (Saturday & Sunday is non-working day)
     * startDate
     * endDate
     * return count of working days
     * */
    public static Integer countWorkingDays(Date startDate, Date endDate){
        Date fromDate = Date.valueOf(startDate);
        Date toDate = Date.valueOf(endDate);
        Integer workingDays = 0;
        if (startDate>toDate) {
            System.debug('start date must be less than to end date');
        }
       
        for(DateTime index = fromDate ; index <= toDate ; index = index.addDays(1)){
            
            if(index.format('EEEE') != 'Saturday' && index.format('EEEE') != 'Sunday') {
					workingDays++;
			}
		}
        return workingDays;
    }
}