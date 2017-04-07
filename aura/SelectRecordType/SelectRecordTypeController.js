({
	doInit : function(cmp, event, helper) {
		helper.getRecordTypes(cmp);
	},
    next : function(cmp,event,helper){
        helper.createAccount(cmp,event);
    },
    setRecordType : function(cmp,event,helper){
        helper.setRecordType(cmp,event);
    },
    cancel : function(cmp,event,helper){
        var modal = cmp.find('selectRecordTypeModal');
        var backdrop = cmp.find('recordTypeBackdrop');
        $A.util.removeClass(modal,'slds-fade-in-open');
        $A.util.removeClass(backdrop,'slds-backdrop--open');
    },
    selectRecordType : function(cmp,event,helper){
        var modal = cmp.find('selectRecordTypeModal');
        var backdrop = cmp.find('recordTypeBackdrop');
        $A.util.addClass(modal,'slds-fade-in-open');
        $A.util.addClass(backdrop,'slds-backdrop--open');
    }
})