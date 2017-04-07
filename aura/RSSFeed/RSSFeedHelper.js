({
	getFeed : function(component) {
		//get url
		var url = component.get("v.theUrl");
        console.log(component.get("v.theHeader"));
        console.log(url);
		var action = component.get("c.getRSSFeed");   
        action.setParams({"url":url});
        
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                console.log(response.getReturnValue());
        		component.set("v.feedItems", response.getReturnValue());
        	}
        });
        $A.enqueueAction(action);
	}
})