({
	render :function(cmp,helper){
    	var ret = this.superRender();
        helper.setActions(cmp);
    	return ret;

    },
    rerender : function(cmp, helper){
    	this.superRerender();
        helper.setActions(cmp);
	}
})