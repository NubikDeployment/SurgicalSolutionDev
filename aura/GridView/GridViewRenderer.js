({
    rerender : function(cmp,helper){
        this.superRerender();
        helper.scrollToActive(cmp);
    }
})