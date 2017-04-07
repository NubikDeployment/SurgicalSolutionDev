({
    render :function(cmp,helper){
    	var ret = this.superRender();
        helper.updateSearch(cmp);
        helper.enableNewButton(cmp);
    	return ret;

    },
    rerender : function(cmp, helper){
    	this.superRerender();
      helper.updateSearch(cmp);
      helper.enableNewButton(cmp);
	}
})