({
	doInit : function(component, event, helper) {
        helper.pullFeedItems(component);
	},
    
    getComment : function(component,event,helper) {
        console.log('in');
        helper.doChatterPost(component);
        
    }
})