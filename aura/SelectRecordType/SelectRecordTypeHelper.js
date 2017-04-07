({
	getRecordTypes : function(cmp) {
		var action = cmp.get('c.getRecordTypes');
        action.setCallback(this,function(response){
            var state = response.getState();
           	var data = response.getReturnValue();
            if (cmp.isValid() && state ==='SUCCESS')
            {
     			cmp.set('v.recordtypes',data);           
            }
		});
        $A.enqueueAction(action);
    },
    
    createAccount:function(cmp,event){
        var recordtype = cmp.get('v.selectedRecordType');
        if ((typeof sforce != 'undefined') && (sforce != null) ){
        	sforce.one.createRecord("Account",recordtype);
        }else{
        	var createRecordEvent = $A.get("e.force:createRecord");
    		createRecordEvent.setParams({
       			"entityApiName": "Account",
                "recordTypeId" : recordtype 
    		});
    		createRecordEvent.fire();
        }
    },
    setRecordType :function(cmp,event){
    	var radio = event.target;
        cmp.set('v.selectedRecordType',radio.id);
	}
})