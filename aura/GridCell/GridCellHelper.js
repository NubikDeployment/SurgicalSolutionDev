({
	loadRelatedList : function(cmp,accountId) {
    	var action = cmp.get('c.getRelatedLists');
       	action.setParams({
        	"accountId": cmp.get('v.id')
        	});
       	action.setCallback(this,function(response){
        	var state = response.getState();
           	var data = response.getReturnValue();
            if (cmp.isValid() && state ==='SUCCESS')
           	{
                data.account.opportunitiesCount = data.opportunities.length;
               	data.account.casesCount = data.cases.length;
               	cmp.set('v.account',data.account);
               	cmp.set('v.cases',data.cases);
                cmp.set('v.opportunities',data.opportunities);
                cmp.set('v.canReadCaseObject',data.canReadCases);
                cmp.set('v.canReadOpportunityObject',data.canReadOpportunities);
            }
        });
        $A.enqueueAction(action);
	},
    resetHover: function(cmp){
       cmp.set('v.hovering',false);
       this.startTimeOut(cmp);
    },
    startTimeOut : function(cmp){

       var timeout = window.setTimeout(
            $A.getCallback(function() {
                if (cmp.isValid()) {
                    var hovering = cmp.get('v.hovering');
                    if (!hovering){
                        var panel = cmp.find('accountName');
                        $A.util.addClass(panel,'hidden');
                    }
                }
            }), 100
        );
        cmp.set('v.timeout',timeout);
    }
})