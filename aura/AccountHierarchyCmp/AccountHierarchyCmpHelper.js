({
	updateSearch : function(cmp) {

       	var isSearching = $A.util.getBooleanValue(cmp.get("v.isSearching"));
        var btnSearch = cmp.find('searchBtn');
       	var inputContainer = cmp.find('searchInputContainer');
       	var btnClose = cmp.find('closeSearch');
        var inputSearch = cmp.find('searchTerm');
   		if (isSearching){
            $A.util.addClass(btnSearch,'search-button__hidden');
       		$A.util.removeClass(inputContainer,'hide');
       		$A.util.removeClass(btnClose,'hide');
            inputSearch.getElement().focus();

        }else{
            $A.util.removeClass(btnSearch,'search-button__hidden');
       		$A.util.addClass(inputContainer,'hide');
       		$A.util.addClass(btnClose,'hide');
        }
	},
	enableNewButton : function(cmp){
		var el = cmp.find('newBtn').getElement();
		var canCreateAccount = $A.util.getBooleanValue(cmp.get('v.canCreateAccount'));
		if (canCreateAccount)
		{
			el.removeAttribute('disabled');
		}	else{
			el.setAttribute('disabled','disabled');
		}
	},
    search : function(cmp){

      var oldTimer = cmp.get('v.timer');
      clearTimeout(oldTimer);
      var timer = setTimeout($A.getCallback(function(){
        var appEvent = $A.get("e.accHierarchy:SearchkeyUpEvent");
        var term = cmp.get('v.term');
        appEvent.setParams({ "searchTerm" : term});
        appEvent.fire();
      }),300);
      cmp.set('v.timer', timer);
    },
    newAccount : function(cmp){
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
    getRecordTypes : function(cmp){
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
    }
})