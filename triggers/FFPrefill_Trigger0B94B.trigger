/**
 * Auto Generated and Deployed by Fast Prefill - Fast Forms
 **/
trigger FFPrefill_Trigger0B94B on Opportunity
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<Opportunity>  newlyInsertedItems =  [SELECT  Id ,  Feedback_URL__c FROM  Opportunity WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( Opportunity e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.UpdateRecordsWithURL ( 'Opportunity' ,  'Feedback_URL__c' ,  'a3t410000005SC8AAM' ,  ids );  
 update newlyInsertedItems;}
}