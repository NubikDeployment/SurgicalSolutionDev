({
    renderWarningIcon : function(component) {
        var svgPath = $A.get('$Resource.LightningDesignSystem') + '/icons/utility-sprite/svg/symbols.svg#warning'
        $A.createComponent("pi:SvgIcon", {
            svgPath : svgPath,
            class : "slds-icon-text-default",
            size : "x-small"
        }, function(icon, status) {
            if(status === "SUCCESS" && component && component.isValid()) {
                component.set("v.iconWarning", icon)
            }
        });
    }
})