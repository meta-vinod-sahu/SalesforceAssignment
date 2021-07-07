@isTest
public class ApexLanguageTestingAssignment {

     static Integer NO_OF_CLASSES = 2;
     static Integer NO_OF_STUDENTS = 5;
    
	@TestSetup
    public static void setupClassAndStudents(){
        List<Class__c> cla = TestFactory.createClassAndRespectiveStudents(NO_OF_CLASSES, NO_OF_STUDENTS);
    	TestFactory.createContactAssociateWithAccount();
    }
    
    @isTest
    public static void testStudentNameByClassId(){
       List<Student__C> students = [SELECT Id, Name From Student__c];
       List<String> expectedResult = Utility.getNameOfStudents(students);
       List<Class__c> classes = [SELECT ID, Name From Class__C];
       List<String> actualResult = new List<String>();
       for(Class__C current : classes){
           List<String> studentNameList = ApexAssignment.getStudentNamesByClassId(current.Id);
           actualResult.addAll(studentNameList);
       }
       System.assertEquals(expectedResult, actualResult, 'results are same');
    }
    
    @isTest
    public static void testCountWorkingDays(){
        Integer expected = 3;
        Integer actual = ApexAssignment.countWorkingDays(Date.newInstance(2020,11,12), Date.newInstance(2020,11,16));
        System.assertEquals(expected, actual, 'results are same');
    }
    
    @isTest
    public static void testAddContactIdToAccount(){
        List<Contact> contacts = [Select Id, Name From Contact];
        String expected = Utility.getContactIdAsString(contacts);
        String actual = Account.addContactIdToAccount(contacts.get(0).Id);
        System.assertEquals(expected, actual, 'results are same');
    }
    
    @isTest static void testGetClassesWithStudents(){
        Map<Class__c, Set<Id>> expectedResult = new Map<Class__c, Set<Id>>();        
        Map<Class__c, Set<Id>> actualResult = ApexAssignment.getClassWiseMapOfStudents();
        List<Class__c> classes = 
        [SELECT Name, Id, (SELECT id, Name FROM Students__r) FROM Class__c];
        Set<Id> studentIds = null;
        for(Class__c classRecord: classes) 
        {
            studentIds = new Set<Id>();
            for(Student__c student: classRecord.Students__r)
            {
                studentIds.add(student.id);
            }
            expectedResult.put(classRecord, studentIds);
        }       

        System.assert(expectedResult.size() == actualResult.size(), 
        'Expected Result Size not matched with Actual Result ');

        Map<Id, Set<Id>> expectedIdSetResult = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> actualIdSetResult = new Map<Id, Set<Id>>();

        for(Class__c classRecord: expectedResult.keySet())
        {
            expectedIdSetResult.put(classRecord.id, expectedResult.get(classRecord));
        }

        for(Class__c classRecord: actualResult.keySet())
        {
            actualIdSetResult.put(classRecord.id, actualResult.get(classRecord));
        }

        Set<Id> expectedClassIds = expectedIdSetResult.keySet();
        Set<Id> actualClassIds = actualIdSetResult.keySet();

        for(Class__c classRecord: expectedResult.keySet())
        {
            System.assert(actualClassIds.contains(classRecord.id), 
            'Actual Classes is different from Expected');
            System.assert(actualClassIds.contains(classRecord.id), 
            'Actual Classes is different from Expected');
            System.assertEquals(expectedIdSetResult.get(classRecord.id),
            actualIdSetResult.get(classRecord.id), 
            'expected Students in Class ' + classRecord.name + ' is Different from actual');            
        }
    }
}