({
    fill : function(component) {
        this.toggleSpinner(component);
        this.toggleBody(component);
        var action = component.get("c.getActions");
        component.set("v.historyComponents", [])
        var totalPages = 0;
        var limit = component.get("v.limit");
        if (component.get("v.componentMode").toLowerCase().trim() !== "custom") {
            component.set("v.recordType", "other");
        }
        action.setParams({
            "recordId": component.get("v.recordId"),
            "recordType": component.get("v.recordType"),
            "sObjectName": component.get("v.sObjectName")
        });
        action.setCallback(this, function(response) {
            this.toggleSpinner(component);
            this.toggleBody(component);
            if (response.getState() === 'SUCCESS') {
                var data = response.getReturnValue();
                var errorTextElement = component.find('errorText');
                if (data.length > 0) {
                    $A.util.removeClass(errorTextElement, 'error-text');
                    component.set("v.hasActivities", true);
                    totalPages = Math.ceil(data.length / limit);
                    component.set("v.totalPages", totalPages);
                    component.set("v.data", data);
                    component.set("v.page", 1);
                } else {
                    component.set("v.hasActivities", false);
                    component.set("v.errorText", "No engagement history to display");
                    $A.util.addClass(errorTextElement, 'error-text');
                }
                this.showActivities(component, 1);
            } else if (response.getState() === 'ERROR') {
                var error = response.getError();
                var message = "An error has occurred";
                var messageParams = {};
                if (error && error.length > 0) {
                    if (error[0].message === 'PardotSalesforceSSONotSet') {
                        messageParams.showUnlinkedAccountMessage = true;
                    } else if (error[0].message === 'PardotApiTimeoutError') {
                        messageParams.showPardotApiTimeoutMessage = true;
                    }
                }
                this.setErrorMessage(message, component, messageParams);
            }
        });
        $A.enqueueAction(action);
    },
    setErrorMessage : function(message, component, params) {
        params = params || {};
        $A.createComponent("pi:ErrorMessage", {
                "title": params.title || "",
                "severity": params.severity || "error",
                "message": message,
                "showUnlinkedAccountMessage": params.showUnlinkedAccountMessage || false,
                "showPardotApiTimeoutMessage": params.showPardotApiTimeoutMessage || false
            },
            function (errorMessage, status) {
                if (status === "SUCCESS") {
                    component.set("v.errorComponent", errorMessage);
                }
            }
        );
    },
    supportedObjectNames : [
        'Lead',
        'Contact',
        'Account'
    ],
    checkIfSupportedObjectName : function(component) {
        var me = this;
        return new Promise(function (resolve, reject) {
            var sObjectName = component.get("v.sObjectName");
            if (me.supportedObjectNames.indexOf(sObjectName) > -1 || component.get("v.componentMode").toLowerCase().trim() === "custom") {
                if (sObjectName === 'Account') {
                    var isPersonAccount = component.get("c.isPersonAccount");
                    isPersonAccount.setParams({
                        "recordId": component.get("v.recordId")
                    });
                    // 'me' is needed here because LAB requires this parameter on the setCallback function
                    isPersonAccount.setCallback(me, function(d) {
                        if (d.getReturnValue() !== false) {
                            resolve();
                        } else {
                            reject('unsupportedEntity');
                        }
                    });
                    $A.enqueueAction(isPersonAccount);
                } else {
                    resolve();
                }
            } else {
                reject('unsupportedEntity');
            }
        });
    },
    createActivityComponents : function(activities, component) {
        var definitions = this.buildDefinitionsFromActivities(activities);
        $A.createComponents(definitions, function(components, status) {
            if (status === "SUCCESS" && component && component.isValid()) {
                component.set("v.historyComponents", components);
            }
        });
    },
    showActivities : function(component, page) {
        page = page || 1;
        var data = component.get("v.data");
        var limit = component.get("v.limit");
        var numOfPages = component.get("v.totalPages");
        var isLastPage = page == (numOfPages - 1) ? true : false;
        var isFirstPage = page == 2 ? true : false;
        if (page <= numOfPages) {
            var start = limit*(page - 1);
            var end = limit*page;
            if (end > data.length) {
                end = data.length;
            }
            var ehPaginator = component.find("engHistPaginator");
            ehPaginator.indexChange(start+1, end, isLastPage, isFirstPage);
            if (data.length > 5) {
                ehPaginator.setShowPaginator(true);
            }
            this.createActivityComponents(data.slice(start, end), component);
        }
    },
    buildDefinitionsFromActivities : function(activities) {
        var definitions = new Array()
        for(var i=0;i<activities.length;i++) {
            var activity = activities[i]
            definitions.push(["pi:EngagementHistoryListItem", {"item":activity}])
        }
        return definitions;
    },
    toggleSpinner: function(component) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hidden")
    },
    toggleBody: function(component) {
        var lcbody = component.find("lcbody");
        $A.util.toggleClass(lcbody, "slds-hidden")
    }
});