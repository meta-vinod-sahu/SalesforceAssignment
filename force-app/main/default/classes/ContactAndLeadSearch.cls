public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(string str)
{
    List<List<sObject>> searchList = [FIND :str IN all fields 
RETURNING Contact(FirstName,LastName) ,Lead(FirstName,Lastname)];
//Contact[] searchContacts = (Contact[])searchList[0];
//Lead[] searchLeads = (Lead[])searchList[1];
return searchList;
   

}
}