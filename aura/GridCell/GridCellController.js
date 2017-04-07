({
    showRelatedRecords: function(cmp,event,helper){
        
    	var to = window.setTimeout(
        	$A.getCallback(function() {
            	if (cmp.isValid()) {
                	cmp.set('v.hovering',true);
                   	var timeOut =  cmp.get('v.timeout');
                   	if (timeOut > 0) {
                    	clearTimeout(timeOut);
                   	}
                   	var panel = cmp.find('accountName');
                   	var id = cmp.get('v.id');
                   	if (cmp.get('v.account')==null){
                    	helper.loadRelatedList(cmp,id);
                   	}
                   	$A.util.removeClass(panel,'hidden');
               	}
           	}), 500
        );
        var timers = cmp.get('v.timers');
        timers.push(to);
    },
    
    hideRelatedRecords : function(cmp,event,helper){
       var timers = cmp.get('v.timers');
       for (var i=0; i < timers.length; i++){
       	  var item = timers[i];
          clearTimeout(item); 
       }
       helper.resetHover(cmp); 
    },
    onHoverPanel : function(cmp,event,helper){
    	cmp.set('v.hovering',true);
        helper.startTimeOut(cmp);
        
	},
 	onLeavePanel : function(cmp,event,helper){
        helper.resetHover(cmp);
    }
})