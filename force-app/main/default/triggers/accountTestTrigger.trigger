/*
* Issues with trigger given in assignment - 
* 1.SOQL Query was written inside the loop
* 2.Nested for loops used
* 3.Update statement was written inside the loop
* 4.Unnecessary field was retrieved via SOQL query i.e email
*/ 

trigger accountTestTrigger on Account (before insert, before update) {
    List<Contact> contacts = [select id, salutation, firstname, lastname from Contact where accountId IN :Trigger.New];
    for(Contact c: contacts) {
        System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '],LastName[' + c.lastname +']');
        c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
    }
    update contacts;
}