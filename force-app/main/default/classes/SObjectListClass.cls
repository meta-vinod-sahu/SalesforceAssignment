public class SObjectListClass {

    public static List<String> getObjects(){
        List<String> objectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
           String name = objTyp.getDescribe().getName();
           String label = objTyp.getDescribe().getLabel();
                System.debug(name);
                objectList.add(name);           
        }
		System.debug(objectList);
        if(objectList != null && objectList.size() > 0){
        	return objectList;   
        }else{
            return null;
        }
}
}