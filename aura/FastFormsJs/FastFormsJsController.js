({
   
	 
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getEmbedLink");
        action.setParams({ hostedFormId : component.get("v.hostedFormCode") });

        action.setCallback(this, function(response){
              var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.jsScriptSrc", response.getReturnValue());
                var scriptElem = document.createElement('script');
        var isEmpty=$A.util.isEmpty(component.get("v.jsScriptSrc"));
        if(!isEmpty){  
            
            scriptElem.src =component.get("v.jsScriptSrc");
            scriptElem.type = "text/javascript";
        scriptElem.id = "jsFastForms";       
            $('#jsFastFormsWrapper').append(scriptElem);
        }else{
            console.log('Not able to find Fast Forms JS snippet');
        }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
         $A.enqueueAction(action);
    }
    
     
})