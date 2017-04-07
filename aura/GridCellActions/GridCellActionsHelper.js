({
	setActions : function(cmp) {
		var el = cmp.find('editAccountBtn').getElement();
        var account = cmp.get('v.account');
        var canEdit = account.accessControl.canEditAccount;
        if (canEdit){
        	el.removeAttribute('disabled');
        }else{
        	el.setAttribute('disabled','disabled');
        }
	},
    hideDropDown : function(cmp){
    	var oldTimer = cmp.get('v.timer');
        clearInterval(oldTimer);
        var timer = setTimeout($A.getCallback(function(){
			if (cmp.isValid()) {
				cmp.set('v.isOpen', false);
			 }
        }),300);
        cmp.set('v.timer', timer);
    },
    checkParent : function(cmp,el){
        var component = cmp.getElement();
        if (component == null) return null;
        while (el.id!=component.id)  {
            if (el.id=='parent-container') return null;
            el = el.parentNode;
            if (!el) {
                return null;
            }
        }
        return el;
	}
})