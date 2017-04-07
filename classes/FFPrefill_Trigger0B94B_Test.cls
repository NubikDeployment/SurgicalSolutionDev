/**
 * Auto Generated and Deployed by Fast Prefill - Fast Forms
 **/
@IsTest
private class FFPrefill_Trigger0B94B_Test
{
    @IsTest
private static void testTrigger()
    {
   Test.startTest();
   Opportunity primaryObject= new Opportunity( Name='test', StageName=getPickValue('Opportunity','StageName'), CloseDate=system.today(), Procedure_Data_Time__c=Datetime.now(), Procedure_End_Date_Time__c=Datetime.now());
 insert primaryObject;
  System.assert(Limits.getFutureCalls()>0);
 Test.stopTest();   
 }

 static String getPickValue(String objName, String fld){ 
 String firstPicklistVal=''; 
  Schema.SObjectType sobjectType= Schema.getGlobalDescribe().get(objName);   
  // Get a map of fields for the SObject 
 map<String, Schema.SObjectField> fieldMap = sobjectType.getDescribe().fields.getMap(); 
  // Get the list of picklist values for this field. 
 list<Schema.PicklistEntry> values = 
 fieldMap.get(fld).getDescribe().getPickListValues(); 
 // Add these values to the selectoption list. 
 if(values!=null && values.size()>0){ firstPicklistVal=values[0].getValue()+'';} 
 return firstPicklistVal; 
 } 

}