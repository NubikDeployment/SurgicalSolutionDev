showSetupUsers();

function autoSetup() {
    var inputServicePresence = $('#service-presence-name').val().trim();
    var inputRoutingConfig = $('#routing-config-name').val().trim();
    var inputQueue = $('#queue-name').val().trim();
    var inputPermissionSet = $('#permission-set-name').val().trim();
    var inputSosDeployment = $('#sos-deployment-name').val().trim();

    if (!(inputServicePresence && inputRoutingConfig && inputQueue && inputPermissionSet && inputSosDeployment)) {
        alert('All objects require a name');
        return false;
    }

    sosData.servicePresence.name = inputServicePresence;
    sosData.routingConfig.name = inputRoutingConfig;
    sosData.queue.name = inputQueue;
    sosData.permissionSet.name = inputPermissionSet;
    sosData.sosDeployment.name = inputSosDeployment;

    setDevNames();

    var servicePresenceResult = createServicePresence();
    var routingConfigResult = createRoutingConfig();
    var queueResult = createQueue();
	var permissionSetResult = updatePermissionSet();
    var sosDeploymentResult = createSOSDeployment();

    $('#create-results').show();

    var q = "SELECT Id FROM sos_auto_setup__c";
    var records = soqlCall(q);

    var exists = records.length && records[0].Id

    var customSetting = new sforce.SObject("sos_auto_setup__c");

    var everythingPassed = true;

    if (servicePresenceResult.success) {
    	customSetting.service_presence__c = sosData.servicePresence.name;
    } else {
        everythingPassed = false;
    }

    if (routingConfigResult.success) {
        customSetting.routing_config__c = sosData.routingConfig.name;
    } else {
        everythingPassed = false;
    }

    if (queueResult.success) {
        customSetting.queue__c = sosData.queue.name;
    } else {
        everythingPassed = false;
    }

    if (permissionSetResult.success) {
        customSetting.permission_set__c = sosData.permissionSet.name;
    } else {
        everythingPassed = false;
    }

    if (sosDeploymentResult.success) {
        customSetting.deployment__c = sosData.sosDeployment.name;
    } else {
        everythingPassed = false;
    }

    if (everythingPassed) {
        $('#setup-users').show();
    } else {
         $('#setup-users').hide();
    }

    $('#setup-users-result').hide();

    if (exists) {
        customSetting.Id = exists;
        result = sforce.connection.update([customSetting]);
    } else {
        result = sforce.connection.create([customSetting]);
    }

    displayResult(servicePresenceResult, 'service-presence');
    displayResult(routingConfigResult, 'routing-config');
    displayResult(queueResult, 'queue');
    displayResult(permissionSetResult, 'permission-set');
    displayResult(sosDeploymentResult, 'sos-deployment');
}

function getDataFromId(id) {
    var dashPos = id.indexOf('-');

    if (dashPos == -1) {
        return sosData[id];
    }

    var charToUpperCase = id.charAt(dashPos + 1).toUpperCase();

    var key = id.substr(0,dashPos) + charToUpperCase + id.substr(dashPos+2);

	return sosData[key]
}

function linkBuilder(elId) {
    var objId = getDataFromId(elId).id;

    if (elId == 'queue') {
        return '/p/own/Queue/e?id='+objId;
    }

    return '/'+objId+'/e';
}

function createServicePresence() {
    checkServicePresenceStatus();

    var msg;
    var result;

    if (sosData.servicePresence.id && sosData.servicePresence.serviceChannel) {
        return {
            success: true,
            msg: 'Already exists'
        };

    } else if (!sosData.servicePresence.id) {
        var servicePresenceCreate = new sforce.SObject("ServicePresenceStatus");
        servicePresenceCreate.DeveloperName = sosData.servicePresence.devName;
        servicePresenceCreate.MasterLabel = sosData.servicePresence.name;

        result = sforce.connection.create([servicePresenceCreate]);

        msg = 'Created';
        sosData.servicePresence.id = result[0].id;
    }

    var wasCreated = result && result.length && result[0].getBoolean("success");

    if (wasCreated || sosData.servicePresence.id) {
        var serviceChannelStatusCreate = new sforce.SObject('ServiceChannelStatus');
        serviceChannelStatusCreate.ServicePresenceStatusId = sosData.servicePresence.id;
        serviceChannelStatusCreate.ServiceChannelId = sosData.serviceChannelId;

        result = sforce.connection.create([serviceChannelStatusCreate]);

        if (result[0].getBoolean("success")) {
            sosData.servicePresence.serviceChannel = true;
            return {
                success: true,
                msg: msg || 'Service Channel added'
            };
        }
        msg = result && result[0] && result[0].errors && result[0].errors.message;

        return {
            success: false,
            msg: msg || "Could not create"
        };
    }
    msg = result && result[0] && result[0].errors && result[0].errors.message;

    return {
        success: false,
        msg: msg || "Could not create"
    };
}

function createRoutingConfig() {
    checkRoutingConfig();

    var msg;
    var result;

    if (sosData.routingConfig.id && sosData.routingConfig.capacity && sosData.routingConfig.serviceChannel) {
        return {
            success: true,
            msg: 'Already exists'
        };

    } else if (!sosData.routingConfig.id) {
        var routingConfigCreate = new sforce.SObject("QueueRoutingConfig");
        routingConfigCreate.DeveloperName = sosData.routingConfig.devName;
        routingConfigCreate.MasterLabel = sosData.routingConfig.name;
        routingConfigCreate.RoutingModel  = 'LeastActive';
        routingConfigCreate.RoutingPriority = 1;
        routingConfigCreate.CapacityPercentage = 51;
        routingConfigCreate.ServiceChannelId = sosData.serviceChannelId;

        result = sforce.connection.create([routingConfigCreate]);
        msg = 'Created';
    }

    var wasCreated = result && result.length && result[0].getBoolean("success");

    if (wasCreated || sosData.routingConfig.id) {
        sosData.routingConfig.id = sosData.routingConfig.id || result[0].id;

        if (!wasCreated) {
            //it existed but did not have the service channel set
            var routingConfigUpdate = new sforce.SObject("QueueRoutingConfig");
            routingConfigUpdate.Id = sosData.routingConfig.id;
            routingConfigUpdate.ServiceChannelId  = sosData.serviceChannelId;
            routingConfigUpdate.CapacityPercentage = 100;

            result = sforce.connection.update([routingConfigUpdate]);

            if (!result[0].getBoolean("success")) {
                var errMsg = result && result[0] && result[0].errors && result[0].errors.message;
                return {
                    success: false,
                    msg: errMsg || "Could not set Service Channel"
                };
            }
			msg = 'Service Channel and/or Capacity updated';
            sosData.routingConfig.serviceChannel = true;
        }

        return {
            success: true,
            msg: msg || 'Created'
        };
    }

    msg = result && result[0] && result[0].errors && result[0].errors.message;

    return {
        success: false,
        msg: msg || 'Could not create Routing Config'
    };
}

function createQueue() {
    if (!sosData.routingConfig.id) {
        return {
            success: false,
            msg: 'Routing config required to create Queue'
        };
    }

    checkQueue();

    var msg;
    var result;
    var wasUpdated;

    if (sosData.queue.id && sosData.queue.routingConfig && sosData.queue.object) {
        return {
            success: true,
            msg: 'Already exists'
        };

    } else if (!sosData.queue.id) {
        //nothing exists, create every thing
        var queueCreate = new sforce.SObject("Group");
        queueCreate.DeveloperName = sosData.queue.devName;
        queueCreate.Name = sosData.queue.name;
        queueCreate.QueueRoutingConfigId = sosData.routingConfig.id;
        queueCreate.Type = 'Queue';

        result = sforce.connection.create([queueCreate]);

        var wasCreated = result.length && result[0].getBoolean("success");

        if (wasCreated) {
            msg = 'Created';
            sosData.queue.id = result[0].id;
        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Unable to create'
            };
        }
    } else if (!sosData.queue.routingConfig) {
        //queue exists, routing config not assigned
        var queueUpdate = new sforce.SObject("Group");
        queueUpdate.Id = sosData.queue.id;
        queueUpdate.QueueRoutingConfigId = sosData.routingConfig.id;
        result = sforce.connection.update([queueUpdate]);

        wasUpdated = result.length && result[0].getBoolean("success");

        if (wasUpdated) {
            msg = 'Updated Routing Config';
            sosData.queue.routingConfig = true;
        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Unable to update Routing Config'
            };
        }
    }

    if (!sosData.queue.object) {
        var queueObjectUpdate = new sforce.SObject("QueueSobject");
        queueObjectUpdate.QueueId = sosData.queue.id;
        queueObjectUpdate.SobjectType = 'SOSSession';
        result = sforce.connection.create([queueObjectUpdate]);

        var objectAssigned = result.length && result[0].getBoolean("success");

        if (objectAssigned) {
            sosData.queue.object = true;
            if (wasUpdated) {
                msg = 'Updated Routing Config and assigned SOS Session';
            } else {
                msg = 'Assigned SOS Session';
            }
        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Unable to assign SOS Session'
            };
        }
    }

    return {
        success: true,
        msg: msg
    };
}

function updatePermissionSet() {
    checkPermissionSet();

    var msg ='';

    if (sosData.permissionSet.id && sosData.permissionSet.servicePresenceStatus && sosData.permissionSet.sosEnabled) {
         return {
            success: true,
            msg: 'Already exists'
        };
    }

    if (!sosData.permissionSet.id) {
        var permissionSetCreate = new sforce.SObject("PermissionSet");
        permissionSetCreate.Name = sosData.permissionSet.devName;
        permissionSetCreate.Label = sosData.permissionSet.name;
        permissionSetCreate.PermissionsEnableSOS = 'true';

        result = sforce.connection.create([permissionSetCreate]);

        var wasCreated = result.length && result[0].getBoolean("success");

        if (wasCreated) {
            msg = 'Created and assigned Service Presence Status';
            sosData.permissionSet.id = result[0].id;
        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Unable to create'
            };
        }
    } else if (!sosData.permissionSet.sosEnabled) {
        var permissionUpdate = new sforce.SObject("PermissionSet");
        permissionUpdate.Id = sosData.permissionSet.id;
        permissionUpdate.PermissionsEnableSOS = 'true';

        result = sforce.connection.update([permissionUpdate]);

        if (result.length && result[0].getBoolean("success")) {
            sosData.permissionSet.sosEnabled = true;
            msg = 'SOS Licenses Enabled';

            if (sosData.permissionSet.servicePresenceStatus) {
                return {
                    success: true,
                    msg: msg
                };
            }

        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Could not update '
            };
        }
    }

    if (!sosData.servicePresence.id) {
        return {
            success: false,
            msg: 'Service Presence Status required to update Permission Set'
        };
    }

    var setupEntityAccessCreate = new sforce.SObject("SetupEntityAccess");
	setupEntityAccessCreate.ParentId = sosData.permissionSet.id;
    setupEntityAccessCreate.SetupEntityId = sosData.servicePresence.id;
    var result = sforce.connection.create([setupEntityAccessCreate]);

    sosData.permissionSet.servicePresenceStatus = result.length && result[0].getBoolean("success");

    if (sosData.permissionSet.servicePresenceStatus) {
        if (msg) {
            msg += ' And ';
        }
        msg += 'Assigned Service Presence Status';

    } else {
		msg = (result && result[0] && result[0].errors && result[0].errors.message) || 'Could not assign Service Presence Status';
    }

    return {
        success: sosData.permissionSet.servicePresenceStatus,
        msg: msg
    };
}

function createSOSDeployment() {

    if (!sosData.queue.id) {
        return {
            success: false,
            msg: 'Queue required to create SOS Deployment'
        };
    }

    checkSOSDeployment();

    if (sosData.sosDeployment.id && sosData.sosDeployment.queue && sosData.sosDeployment.enabled) {
        return {
            success: true,
            msg: 'Already exists'
        };
    }

    var result;
    var msg;

    if (!sosData.sosDeployment.id) {
        var sosDeploymentCreate = new sforce.SObject("SOSDeployment");
        sosDeploymentCreate.QueueId = sosData.queue.id;
        sosDeploymentCreate.OptionsIsEnabled = 'true';
        sosDeploymentCreate.DeveloperName = sosData.sosDeployment.devName;
        sosDeploymentCreate.MasterLabel = sosData.sosDeployment.name;

        result = sforce.connection.create([sosDeploymentCreate]);

        if (result.length && result[0].getBoolean("success")) {
            sosData.sosDeployment.id = result[0].id;
            sosData.sosDeployment.queue = true;
            sosData.sosDeployment.enabled = true;
            getAllDeployments();
            return {
                success:true,
                msg: 'Created'
            };
        } else {
            msg = result && result[0] && result[0].errors && result[0].errors.message;

            return {
                success: false,
                msg: msg || 'Unable to create'
            };
        }
    }

    var sosDeploymentUpdate = new sforce.SObject("SOSDeployment");
    sosDeploymentUpdate.Id = sosData.sosDeployment.id;

    if (!sosData.sosDeployment.queue) {
        sosDeploymentUpdate.QueueId = sosData.queue.id;

        msg = 'Queue ';
    }

    if (!sosData.sosDeployment.enabled) {
        sosDeploymentUpdate.OptionsIsEnabled = 'true';

        if (msg) {
            msg += 'and Enabled';
        } else {
            msg = 'Enabled';
        }
    }

    result = sforce.connection.update([sosDeploymentUpdate]);

    if (result.length && result[0].getBoolean("success")) {
        sosData.sosDeployment.queue = true;
        sosData.sosDeployment.enabled = true;

        return {
            success: true,
            msg: 'Updated ' + msg
        };
    } else {
        msg = result && result[0] && result[0].errors && result[0].errors.message;

        return {
            success: false,
            msg: msg || 'Could not update ' + msg
        };
    }
}

//USER SETUP
function showSetupUsers() {
    var searchVal = $('#search-setup-users').val();
    $('#setup-user-list option').remove();

    var userList = $('#setup-user-list');

    if (!searchVal) {
        buildOption(userList, 0, '-- SELECT USER --');
    }

    if (!sosData.allUsers) {
        console.log('NO USERS (sosData.allUsers)', sosData);
        return;
    }

    for (var i = 0; i < sosData.allUsers.length; i++) {
        if (!searchVal || sosData.allUsers[i].Name.toLowerCase().indexOf(searchVal.toLowerCase()) != -1) {
            buildOption(userList, sosData.allUsers[i].Id, sosData.allUsers[i].Name);
        }
    }

    if (!$('#setup-user-list option').length) {
        buildOption(userList, 0, '-- USER NOT FOUND --');
    }
}

function clearSetupSearch() {
    $('#search-setup-users').val('');
    showSetupUsers();
}

function addUserToQueue() {
    if (!sosData.queue.id) {
        checkQueue();

        if (!sosData.queue.id) {
            return {
                success: false,
                msg: 'Can not add member, queue unknown'
            };
        }
    }

    var userId = $("#setup-user-list option:selected").val();

    if (!userId) {
        return {
            success: false,
            msg: 'User not selected'
        };
    }

    if (userQueueMember(userId)) {
        return {
            success: true,
            msg: 'User already queue memeber'
        };
    }

    var groupMemberCreate = new sforce.SObject("GroupMember");
    groupMemberCreate.GroupId = sosData.queue.id;
    groupMemberCreate.UserOrGroupId = userId;

    var result = sforce.connection.create([groupMemberCreate]);

    if (result.length && result[0].getBoolean("success")) {
        return {
            success: true,
            msg: 'User assigned to queue'
        };
    }

    return {
        success: false,
        msg: 'Unable to add user to queue'
    }
}

function addUserToPermissionSet() {
    if (!sosData.permissionSet.id) {
        checkPermissionSet();

        if (!sosData.permissionSet.id) {
            return {
                success: false,
                msg: 'Can not assign, permission pet unknown'
            };
        }
    }

    var userId = $("#setup-user-list option:selected").val();

    if (!userId) {
        return {
            success: false,
            msg: 'No user selected'
        };
    }

    if (userAssignedPermissionSet(userId)) {
        return {
            success: true,
            msg: 'User already assigned'
        };
    }

    var permissionSetAssignCreate = new sforce.SObject("PermissionSetAssignment");
    permissionSetAssignCreate.PermissionSetId = sosData.permissionSet.id;
    permissionSetAssignCreate.AssigneeId = userId;

    var result = sforce.connection.create([permissionSetAssignCreate]);

    if (result.length && result[0].getBoolean("success")) {
        return {
            success: true,
            msg: 'User assigned to permission set'
        };
    }

    return {
        success: false,
        msg: 'Unable to assign user to permission set'
    }
}

function enableServiceCloud() {
    var userId = $("#setup-user-list option:selected").val();

    if (!userId) {
        return {
            success: false,
            msg: 'No user selected'
        };
    }

    if (userServiceCloudEnabled(userId)) {
        return {
            success: true,
            msg: 'Already enabled'
        }
    }

    var userUpdate = new sforce.SObject("User");
    userUpdate.Id = userId;
    userUpdate.UserPermissionsSupportUser = 'true';

    var result = sforce.connection.update([userUpdate]);

    if (result.length && result[0].getBoolean("success")) {
        return {
            success: true,
            msg: 'Enabled'
        };
    }

    return {
        success: false,
        msg: 'Could not enable'
    }
}

function assignLicense() {
    var userId = $("#setup-user-list option:selected").val();
    if (!sosData.licenseId) {
        return {
            succes: false,
            msg: 'SOS License Required'
        };
    }

    var q = "SELECT Id FROM PermissionSetLicenseAssign "
    	+ "WHERE PermissionSetLicenseId  = '" + escapeSoql(sosData.licenseId) + "' AND "
    	+ "AssigneeId = '" + escapeSoql(userId) + "'";

    var records = soqlCall(q);

    if (records.length) {
        return {
            success: true,
            msg: 'Already assigned'
        };
    }

    var assignLicenseInsert = new sforce.SObject("PermissionSetLicenseAssign");
    assignLicenseInsert.PermissionSetLicenseId = sosData.licenseId;
    assignLicenseInsert.AssigneeId = userId;

    var result = sforce.connection.create([assignLicenseInsert]);

    if (result.length && result[0].getBoolean("success")) {
        return {
            success: true,
            msg: 'License assigned to user'
        };
    }

    console.log('License Assign Issue:', result);
    return {
        success: false,
        msg: 'Unable to assign license'
    };
}

function displayResult(results, elId) {
    var resultEl = $('#'+elId+'-result');
    var editLink = $('#'+elId+'-edit-link');

    $('#'+elId+'-msg').text(results.msg);

    if (results.success) {
    	resultEl.addClass('pass').removeClass('fail').text('PASS');
        if (editLink.length) {
            editLink.show().attr('href', linkBuilder(elId));
        }

    } else {
        resultEl.addClass('fail').removeClass('pass').text('FAIL');
        editLink.hide();
    }
}

function getAllDeployments() {
    var q = "SELECT Id, MasterLabel FROM SOSDeployment WHERE OptionsIsEnabled = true";
    var allDeployments = soqlCall(q);
    var deploySelect = $('#deployment-list');
    deploySelect.empty();
    buildOption(deploySelect, 0, '-- SELECT DEPLOYMENT --');

    if (allDeployments && allDeployments.length) {
        for (var i = 0; i < allDeployments.length; i++) {
            allDeployments[i].Id = allDeployments[i].Id.substr(0,15); //use 15 char id
            buildOption(deploySelect, allDeployments[i].Id, allDeployments[i].MasterLabel);
        }
    }
}

//ON EVENTS
$('#auto-setup').click(function() {
    autoSetup();
});

$('#find-setup-users-button').click(function() {
    showSetupUsers();
    $("#setup-user-result").hide();
});

$('#clear-setup-search-button').click(function() {
    clearSetupSearch();
});

$('#setup-user-list').change(function() {
    $("#setup-user-result").hide();
});

$('#find-profiles-button').click(function() {
    showProfiles();
});

$('#clear-profiles-button').click(function() {
    clearProfilesSearch();
});

$("#search-setup-users").keyup(function (e) {
    if (e.keyCode == 13) {
        // Enter key pressed
        showSetupUsers();
    }
});

$('.auto-names').change(function() {
    $('#create-results').hide();
    $('#setup-users').hide();
    $('#setup-user-result').hide();
});
