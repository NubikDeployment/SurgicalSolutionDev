({
	doInit : function(cmp, event, helper) {

		var recordId = cmp.get('v.recordId');
		var action = cmp.get('c.getPreviewHierarchy');
		action.setParams({accountId: recordId});
		action.setCallback(this,function(response){
        	var state = response.getState();
           	var data = response.getReturnValue();			
            if (cmp.isValid() && state ==='SUCCESS') {
        	  var rows = data.rows;
			  rows.forEach(function(item){
				 item.cells = item.cells.slice(1,4);
			  }); 
			  rows[rows.length-1].lastRow = true;
			  cmp.set('v.rows', data.rows);
              if (!data.isHierarchyResolved){
                cmp.set('v.errorMessage',cmp.get('v.hierarchyResolvedMessage'));  
              	cmp.set('v.hasError',true);
              }else{
              	cmp.set('v.hasError',false);
              }  
            }else{
                cmp.set('v.hasError',true);
           		cmp.set('v.errorMessage', response.error[0].message);    
            }
        });
        $A.enqueueAction(action);
	},
    viewAll:function(cmp,event,helper){
      
        var urlEvent = $A.get("e.force:navigateToURL");
        var url = "/apex/accHierarchy__Account_Hierarchy_Page?id=" + cmp.get('v.recordId');
        urlEvent.setParams({
            "url":url
        });
    	urlEvent.fire();
    }
})