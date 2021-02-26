/*
* Issues with code given in question - 
* 1.Multiple queries can be reduced by adding predicate in where clause
* 2.Trigger.newMap is not allowed with before delete
* 3.Nested loops were present
* 4.Two if statement could be reduced by using one SOQL statement only
*/

trigger accountTrigger on Account (before delete, before insert, before update) {
    
    if(Trigger.isDelete) {
        
    } else {
        List<Opportunity> opps = [select id, name, closedate, stagename from Opportunity where accountId IN :Trigger.newMap.keySet() and (StageName='Closed - Lost' OR StageName='Closed - Won')];
        for(Opportunity o: opps){
            System.debug('Do more logic here...');
        }
    }
}