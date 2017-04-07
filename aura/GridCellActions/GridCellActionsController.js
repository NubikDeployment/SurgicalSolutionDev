({
	newAccount : function(cmp, event, helper) {
        if ((typeof sforce != 'undefined') && (sforce != null) ){
        	sforce.one.createRecord("Account",null);
        }else{
        	var createRecordEvent = $A.get("e.force:createRecord");
    		createRecordEvent.setParams({
       			"entityApiName": "Account"
    		});
    		createRecordEvent.fire();
        }
	},
 	editAccount: function(cmp,event,helper){
		cmp.set('v.isOpen',false);
        var canEdit = cmp.get('v.account.accessControl.canEditAccount');
        if (!canEdit){
            event.preventDefault();
            return;
        }
        var recordId =cmp.get("v.account.id");
        var appEvent = $A.get("e.accHierarchy:EditAccountEvent");
        appEvent.setParams({ "editingAccountId" : recordId});
		appEvent.fire();
        if ((typeof sforce != 'undefined') && (sforce != null) ){
            sforce.one.editRecord(recordId);
        }else{
            var editRecordEvent = $A.get("e.force:editRecord");
    		editRecordEvent.setParams({
         		"recordId": recordId
   			});
    		editRecordEvent.fire();
        }
    },
    displayDropdown: function(cmp, event, helper) {
        	 var timer = cmp.get('v.timer');
        	 clearInterval(timer);
        	 cmp.set('v.timer', undefined);
             cmp.set('v.isOpen', !cmp.get('v.isOpen'));
    },
    windowOnClick : function(cmp,event,helper){
        var evnt = event.getParam('evnt');
        var el = evnt.target;
        var parent = helper.checkParent(cmp,el);
        var hide = parent == null ? true : false;
        if (hide){
        	helper.hideDropDown(cmp);
        }
    }
})