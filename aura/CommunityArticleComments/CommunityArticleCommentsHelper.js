({
	pullFeedItems : function(component) {
		//get url
		var url = document.location.href;
		//get title
		var spltStr = url.split("/");
        var title = spltStr[spltStr.length-1];
        component.set("v.theUrl", url);
        component.set("v.theTitle", title);
        console.log(title);
		//pass to backend to get feed items
		var action = component.get("c.getArticleFeedItems");   
        action.setParams({"title":title,"theUrl":url});
        
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                console.log(response.getReturnValue());
        		component.set("v.theFeedItems", response.getReturnValue());
        	}
        });
        $A.enqueueAction(action);
	},
    
    doChatterPost :function(component) {
        console.log('do Chatter Post')
        var comment = component.find("commentBox").get("v.value");
        console.log(comment);
        var title = component.get("v.theTitle");
        console.log(title);
        var action = component.get("c.postToChatter");   
        action.setParams({"comment":comment,"title":title});
        
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                console.log('Successful Post');
                component.find("commentBox").set("v.value","");
        		this.pullFeedItems(component);
        	}
        });
        $A.enqueueAction(action);
    }
})