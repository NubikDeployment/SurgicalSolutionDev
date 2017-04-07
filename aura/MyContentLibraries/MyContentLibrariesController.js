({
    doInit : function(component, event, helper) {
        // Retrieve Library(workspace names) during component initialization
        helper.getLibraryNames(component);
        helper.getFirstLibraryRecordsByWorkSpaceId(component);
        helper.getIsHighVolumeUser(component);
        //helper.getUserRoleId(component);
    },
    displayLibraryRecords: function(component, event, helper){
        //component.set("v.selectedLibraryId",event.target.value);
        component.set("v.selectedLibraryId", event.target.dataset.value);
        helper.getLibraryRecordsByWorkSpaceId(component); // get LibraryRecords
        
    },
    /** formController.js **/
    waiting : function(component, event, helper) {
    	component.set("v.wait", "updating...");
	},
	doneWaiting : function(component, event, helper) {
    	component.set("v.wait", "");
	},
})