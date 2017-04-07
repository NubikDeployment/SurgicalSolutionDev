({
    //preview library content
    libraryContent : function (component, event, helper) {
        //alert('Record: ' + event.target.value);
        $A.getEvt('forceContent:openPreview').setParams({ recordId: event.target.dataset.value }).fire(); 
    }
})