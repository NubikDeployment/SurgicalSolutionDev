({
    render: function(component, helper) {
        var ret = this.superRender();

        helper.renderWarningIcon(component);
        return ret;
    }
})