({
	doInit : function(cmp, event, helper) {
		cmp.set('v.numberOfItems', '0');
		cmp.set('v.active',{name:' none '});
        helper.getRecordTypes(cmp);
	},
	refreshItemAndBread : function(cmp, event, helper) {
       var number = event.getParam('number');
       var active = event.getParam('active');
			 var canCreateAccount = event.getParam('canCreateAccount');
       cmp.set('v.numberOfItems',number);
       cmp.set('v.active', active);
			 cmp.set('v.canCreateAccount',canCreateAccount);
	},

    doSearch : function(cmp,event,helper){
         var wasSearched = $A.util.getBooleanValue(cmp.get('v.wasSearched'));
       	if (!wasSearched){
       		cmp.set('v.wasSearched',true);
       	}
		helper.search(cmp);
    },
    openSearch : function(cmp,event,helper){
       	cmp.set('v.isSearching',true);
        var appEvent = $A.get("e.accHierarchy:OnSearchModeEvent");
		appEvent.setParams({ "isSearchMode" : true});
		appEvent.fire();
    },
    closeSearch: function(cmp,event,helper){
       	cmp.set('v.isSearching',false);
       	var appEvent = $A.get("e.accHierarchy:OnSearchModeEvent");
		appEvent.setParams({ "isSearchMode" : false});
		appEvent.fire();
       	var wasSearched = $A.util.getBooleanValue(cmp.get('v.wasSearched'));
       	if (wasSearched && cmp.get('v.term')!=''){
        	cmp.set('v.term','');
       		helper.search(cmp);
       }
    },
    showToolTip : function(cmp,event,helper){
        var text = event.getParam('hoverText');
        cmp.set('v.gridHoverText',text);
        $A.util.removeClass(cmp.find('gridTooltip'),'slds-hide');
    },
    hideToolTip: function(cmp,event,helper){
        $A.util.addClass(cmp.find('gridTooltip'),'slds-hide');
    },
    newAccount:function(cmp,event,helper){
        if (cmp.get('v.recordtypes').length > 0){
        	var appEvent = $A.get("e.accHierarchy:newAccountEvent");
        	appEvent.fire();
        }else{
          helper.newAccount(cmp);  
        }
    },
    onWindowClick : function(cmp,event,helper){
        var appEvent = $A.get("e.accHierarchy:WindowOnClickEvent");
        appEvent.setParams({"evnt":event});
        appEvent.fire();
    }
})