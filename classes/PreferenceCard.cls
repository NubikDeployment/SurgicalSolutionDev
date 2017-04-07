public class PreferenceCard {
	
	@AuraEnabled
	public static Opportunity getOppById(String theId)
	{
		Opportunity theOpp = [SELECT Id, StageName, Surgeon__c, Owner.Name FROM Opportunity WHERE Id =: theId];

		return theOpp;
	}

	@AuraEnabled
	public static Preference_Card__c getPreferenceCardById(String theId)
	{
		Preference_Card__c thePreferenceCard = [SELECT Id, Legs__c, Arms__c, Patient_Position__c, Room_Setup__c,Stirrups__c, Normal__c FROM Preference_Card__c WHERE Id =: theId];

		return thePreferenceCard;
	}

	@AuraEnabled
	public static Map<String,List<Inventory__c>> getInventories(String theId)
	{
		Map<String,List<Inventory__c>> theMap = new Map<String,List<Inventory__c>>();

		List<Inventory__c> listOfInventory = [SELECT Id, Name, Category__c, Quantity__c FROM Inventory__c WHERE Preference_Card__c =: theId];
		
		for(Inventory__c theInv : listOfInventory)
		{
			if(!theMap.containsKey(theInv.Category__c))
			{
				theMap.put(theInv.Category__c,new List<Inventory__c>());
			}

			theMap.get(theInv.Category__c).add(theInv);
		}

		return theMap;
	}
}