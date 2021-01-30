public class ApexAssignment{
    /**
     * Question: Create A Class & a static Function which takes 
     * classId as argument and returns all names of student in that 
     * class as a list
     * classId: 
     * return
     * 
     * */
    public static List<String> getStudentNamesByClassId(String classId){
        List<Student__C> students = [Select Id, Name, Class__c From Student__C 
                                     WHERE Class__c in (SELECT ID From Class__c Where Id = :classId)];
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
     * 
     * */
    public static Map<String,Set<String>> getClassWiseMapOfStudents(){
        List<Class__C> classes = [Select Id, Name, (Select Id, Name From Students__r) From Class__c];
        Map<String, Set<String>> classWiseMapOfStudents = new Map<String, Set<String>>();
        for(Class__C currentClass: classes){
            String classId = currentClass.Id;
            List<Student__c> students = currentClass.students__r;
            Set<String> studentIds = new Set<String>(); 
            for(Student__c student: students){
                studentIds.add(student.Id);
            }
            classWiseMapOfStudents.put(classId, studentIds);
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
        Date toDate = Date.valueOf(startDate);
        Date fromDate = Date.valueOf(endDate);
        Integer workingDays = 0;
        for(DateTime index = toDate ; index <= fromDate ; index = index.addDays(1)){
			if(index.format('EEEE') != 'Saturday' && index.format('EEEE') != 'Sunday') {
					workingDays++;
			}
		}
        return workingDays;
    }
}