({
 	getLibraryNames : function(cmp) {
        // Load all library names
        var action = cmp.get("c.getLibraryNames");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.libraryNames", response.getReturnValue());
                if(response.getReturnValue() != null){  
                    // set first Library Id
                    cmp.set("v.selectedLibraryId", cmp.get("v.libraryNames")[0].ContentWorkspaceId);
                }
            }
        });    
        $A.enqueueAction(action);
    },
    getIsHighVolumeUser : function(cmp) {
        // check for high volume user
        var act = cmp.get("c.isHighVolumeUser");
        act.setCallback(this, function(a) {
            cmp.set("v.isHighVolumeUser", a.getReturnValue());
        });
        $A.enqueueAction(act);
        
        var art = cmp.get("c.getUserRole");
        art.setCallback(this, function(a) {
            cmp.set("v.userRoleId", a.getReturnValue());
        });
        $A.enqueueAction(art);
        //get User Type
        var uType  = cmp.get("c.getUserType");
        uType.setCallback(this, function(a) {
            cmp.set("v.userType", a.getReturnValue());
        });
        $A.enqueueAction(uType);
        //is Guest User ?
        var gUser  = cmp.get("c.isGuestUser");
        gUser.setCallback(this, function(a) {
            cmp.set("v.isGuestUser", a.getReturnValue());
        });
        $A.enqueueAction(gUser);
    },
    getFirstLibraryRecordsByWorkSpaceId : function(cmp) { 
        // Load first library records
        var action = cmp.get("c.getFirstLibraryRecordsByWorkSpaceId");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.contentWorkspaceDocs", response.getReturnValue());
            }
        });    
        $A.enqueueAction(action);
    },
    getLibraryRecordsByWorkSpaceId : function(cmp ) {
        // Load library records by workspaceId
        var action = cmp.get("c.getLibraryRecordsByWorkSpaceId");
        action.setParams({
            "wsId": cmp.get("v.selectedLibraryId")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.contentWorkspaceDocs", response.getReturnValue());
            }
        });    
        $A.enqueueAction(action);
    },
    getLibraryRecords : function(cmp) { //not used
        // Load all libary records
        var action = cmp.get("c.getRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.contentWorkspaceDocs", response.getReturnValue());
            }
        });    
        $A.enqueueAction(action);
    }
})