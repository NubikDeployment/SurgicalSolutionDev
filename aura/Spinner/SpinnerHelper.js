({
	//helper
	showHideSpinner : function(component) {
       var spinner = component.find('spinner');
       if(component.get('v.show') && $A.util.hasClass(component,'hidden')) {
       		$A.util.removeClass(component,'hidden');
       } else if (!$A.util.hasClass(component,'hidden')){
         	$A.util.addClass(component,'hidden');
      }
	}

})