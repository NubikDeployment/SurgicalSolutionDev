window.sosData = window.sosData || {};
sosData.currentStep = 1;

getAllUsers();
fillInNames();
setDevNames();
licenseCheck();
step1Check();

$('#org-id').text(sosData.orgId);

function fillInNames() {
    $('#service-presence-name').val(sosData.servicePresence.name);
    $('#routing-config-name').val(sosData.routingConfig.name);
	$('#queue-name').val(sosData.queue.name);
	$('#permission-set-name').val(sosData.permissionSet.name);
	$('#sos-deployment-name').val(sosData.sosDeployment.name);
}

function setDevNames() {
    sosData.servicePresence.devName = sosData.servicePresence.name.replace(/ /g,"_");
    sosData.routingConfig.devName = sosData.routingConfig.name.replace(/ /g,"_");
    sosData.queue.devName = sosData.queue.name.replace(/ /g,"_");
    sosData.permissionSet.devName = sosData.permissionSet.name.replace(/ /g,"_");
    sosData.sosDeployment.devName = sosData.sosDeployment.name.replace(/ /g,"_");
}

function escapeSoql(str) {
    return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

function buildOption(selectBox, val, name, selected) {
    //Option not supported in IE9
    if (Option) {
        selectBox.append(new Option(name, val, false, selected));
    } else {
        selectBox.append($('<option></option>').val(val).text(name).prop('selected', selected));
    }
}

function scExists(scName) {
    $('#create-service-channel').hide();
    $('#service-channel-needed').hide();
    $('.service-channel-created').show();
    $('#email-nick').show();
    $('#sc-name').text(scName)
}

function createSC() {
    //no existing SOS service channel, create one
    var serviceChannelCreate = new sforce.SObject("ServiceChannel");
    serviceChannelCreate.DeveloperName = 'SOS_Auto';
    serviceChannelCreate.MasterLabel = 'SOS_Auto';
    serviceChannelCreate.RelatedEntity = 'SOSSession';

    var result = sforce.connection.create([serviceChannelCreate]);

    if (result.length && result[0].getBoolean("success")) {
        sosData.serviceChannelId = result[0].id;
        scExists('SOS_Auto');
        $('#service-channel-status').addClass('pass').removeClass('fail').text('PASS');
    } else {
        emailNick('sos-session-status');
    }
}

function step1Reset() {
    $('.fail').addClass('pass').removeClass('fail').text('PASS');
    $('#email-nick').hide();
    $('#enable-onmi').hide();
    step1Check();
    displayNotify('check-org-notify', 'Omni-Channel is not enabled');
}

function step1Check() {
    var passEverything = true;
    var q;
    var records;


    try {
        q = "SELECT Id FROM ServicePresenceStatus LIMIT 1";
        records = soqlCall(q);
    } catch (err) {
        $('#service-presence-status').addClass('fail').removeClass('pass').text('FAIL');
        $('#bothPass').hide();
        $('.other-checks').hide();
        $('#enable-omni').show();

        openStep1();

        return;
    }

    $('.other-checks').show();
    $('#enable-omni').hide();

    try {
        q = "SELECT Id FROM ServiceChannel WHERE DeveloperName ='sfdc_sos'";
        records = soqlCall(q);
    } catch(err) {
        emailNick('service-channel-status');
        passEverything = false;
        $('#service-channel-edit').hide();
    }

    if (records && records.length) {
        //created service channel exists, will auto pop
        sosData.serviceChannelId = records[0].Id;
    } else {
        //the created Service Channel does not exist,
        //see if the created one exists
        //if not see if user wants a custom one created

        q = "SELECT Id,MasterLabel FROM ServiceChannel WHERE RelatedEntity ='SOSSession'";
        try {
            records = soqlCall(q);
        } catch(err) {
            emailNick('service-channel-status');
            passEverything = false;
            $('#service-channel-edit').hide();
        }

        if (records && records.length) {
            //custom one exists, show message saying what is needed to have auto open
            sosData.serviceChannelId = records[0].Id;
            scExists(records[0].MasterLabel);

        } else if (passEverything) {
			$('#create-service-channel').show();
     		$('#service-channel-needed').show();
            emailNick('service-channel-status');
            passEverything = false;
        }
    }

    try {
        q = "SELECT Id FROM SOSSession LIMIT 1";
        records = soqlCall(q);
    } catch (err) {
        emailNick('sos-session-status');
        passEverything = false;
    }

    if (passEverything) {
        $('#bothPass').text('You have everything you need! Let\'s go to the next step.').show();
    }

}

function emailNick(failed) {
    $('#'+failed).addClass('fail').removeClass('pass').text('FAIL');
    $('#bothPass').hide();
    $('#email-nick').show();

	openStep1();
}

function openStep1() {
    if (!$('#collapse_1').hasClass('in')) {
        $('#accordion2 .in').collapse('hide');
        $('#collapse_1').collapse('show');
    }
}

function licenseCheck() {
    var validLicense = false;

    try {
        // DeveloperName  = 'SosUserPsl'
        // MasterLabel = 'SOS User'
        q = "SELECT Id FROM PermissionSetLicense WHERE MaximumPermissionsEnableSOS = true";
        records = soqlCall(q);

        if (records.length) {
            sosData.licenseId = records[0].Id;
            validLicense = true;
        }
    } catch(err) {
    }

    if (!validLicense) {
        $('#sos-license').addClass('fail').removeClass('pass').text('FAIL');
        $('#license-msg').show();
        $('#bothPass').hide();
        openStep1();
    }
}

//Verification (final step)
function checkServicePresenceStatus() {
    //check for Service Presence Status with specific name
    var q = "SELECT Id FROM ServicePresenceStatus WHERE DeveloperName = '" + escapeSoql(sosData.servicePresence.devName) + "'";
    var records = soqlCall(q);

    sosData.servicePresence.id = records.length && records[0].Id;
    sosData.servicePresence.serviceChannel = false;

    if (sosData.servicePresence.id && sosData.serviceChannelId) {

        //check if correct service channel is selected for the service presence status
        q = "SELECT Id, ServiceChannelId FROM ServiceChannelStatus WHERE "
        + "ServicePresenceStatusId  = '" + escapeSoql(sosData.servicePresence.id) + "' AND "
        + "ServiceChannelId = '" + escapeSoql(sosData.serviceChannelId) + "'";
        var records2 = soqlCall(q);

        sosData.servicePresence.serviceChannel = !!records2.length;
    };
}

function checkRoutingConfig() {
    var q = "SELECT Id, ServiceChannelId, CapacityPercentage FROM QueueRoutingConfig WHERE DeveloperName = '" + escapeSoql(sosData.routingConfig.devName) + "'";
    var records = soqlCall(q);

    sosData.routingConfig.id = false;
    sosData.routingConfig.serviceChannel = false;

    if (records.length) {
        sosData.routingConfig.id = records[0].Id;
        sosData.routingConfig.serviceChannel = records[0].ServiceChannelId && records[0].ServiceChannelId == sosData.serviceChannelId;
        sosData.routingConfig.capacity = records[0].CapacityPercentage;
    }
}

function checkQueue() {
    var q = "SELECT Id, QueueRoutingConfigId FROM Group WHERE DeveloperName = '" + escapeSoql(sosData.queue.devName) + "'";
    var records = soqlCall(q);

    sosData.queue.id = false;
    sosData.queue.routingConfig = false;
    sosData.queue.object = false;

    if (records.length) {
        sosData.queue.id = records[0].Id;
        sosData.queue.routingConfig = records[0].QueueRoutingConfigId == sosData.routingConfig.id;

        q = "SELECT Id FROM QueueSobject WHERE "
        	+ "QueueId  = '" + escapeSoql(sosData.queue.id) + "' AND "
        	+ "SobjectType = 'SOSSession'";
        var records2 = soqlCall(q);

        sosData.queue.object = !!records2.length;
    }
}

function checkPermissionSet() {
    var q = "SELECT Id, PermissionsEnableSOS FROM PermissionSet WHERE Name = '" + escapeSoql(sosData.permissionSet.devName) + "'";
    var records = soqlCall(q);

    sosData.permissionSet.id = records.length && records[0].Id;
    sosData.permissionSet.servicePresenceStatus = false;
    sosData.permissionSet.sosEnabled = records.length && records[0].PermissionsEnableSOS == 'true';

    if (sosData.permissionSet.id && sosData.servicePresence.id) {

        //check if service presence status was assigned to the permission set
        q = "SELECT Id FROM SetupEntityAccess WHERE "
        	+ "ParentId  = '" + escapeSoql(sosData.permissionSet.id) + "' AND "
        	+ "SetupEntityId = '" + escapeSoql(sosData.servicePresence.id) + "'";
        var records2 = soqlCall(q);

        sosData.permissionSet.servicePresenceStatus = !!records2.length;
    }
}

function checkSOSDeployment() {
    var q = "SELECT Id, QueueId, OptionsIsEnabled FROM SOSDeployment WHERE DeveloperName = '" + escapeSoql(sosData.sosDeployment.devName) + "'";
    var records = soqlCall(q);

    sosData.sosDeployment.id = false;
    sosData.sosDeployment.queue = false;
    sosData.sosDeployment.enabled = false;

    if (records.length) {
        sosData.sosDeployment.id = records[0].Id;
        sosData.sosDeployment.queue = records[0].QueueId == sosData.queue.id;
        sosData.sosDeployment.enabled = records[0].OptionsIsEnabled == 'true';
    }
}

//individual Users check
function getAllUsers() {
    var q = "SELECT Id, Name FROM User WHERE IsActive = true AND (UserType = 'Standard' OR UserType = 'Guest') ORDER BY Name ASC NULLS FIRST"
    sosData.allUsers = soqlCall(q);
}

function userServiceCloudEnabled(userId) {
    //UserPermissionsLiveAgentUser UserPermissionsSupportUser
    var q = "SELECT UserPermissionsSupportUser FROM User WHERE Id = '" + escapeSoql(userId) + "'";
    var records = soqlCall(q);

    if (!records.length) {
        return false;
    }

    return records[0].UserPermissionsSupportUser == 'true';
}

//check group members
function userAssignedPermissionSet(userId) {
    if (!sosData.permissionSet.id) {
        return false;
    }

    var q = "SELECT Id FROM PermissionSetAssignment "
     	+ "WHERE PermissionSetId = '" + escapeSoql(sosData.permissionSet.id) + "' AND "
    	+ "AssigneeId = '" + escapeSoql(userId) + "'";
    var records = soqlCall(q);


    if (records.length) {
        return true;
    }

    //Check if permission assigned to profile
    q = "SELECT ProfileId FROM User WHERE Id = '" + escapeSoql(userId) + "'";
    records = soqlCall(q);

    if (!records.length) {
        //should never happen
        alert('Issue checking user, please reload the page.');
        return false;
    }

    var profileId = records[0].ProfileId;

    q = "SELECT Id FROM PermissionSet WHERE ProfileId = '" + escapeSoql(profileId) + "'";

    var allPermissions = soqlCall(q);

    if (!allPermissions.length) {
        //no permissions assigned to this profile
        return false;
    }

    if (!sosData.servicePresence.id) {
        return false;
    }

    q = "SELECT ParentId FROM SetupEntityAccess WHERE SetupEntityId  = '" + escapeSoql(sosData.servicePresence.id) + "'";
    var allServicePresenceRules = soqlCall(q);

    if (!allServicePresenceRules.length) {
        return false;
    }

    for (var i = 0; i < allServicePresenceRules.length; i++) {
        for (var j = 0; j < allPermissions.length; j++) {
            if (allServicePresenceRules[i].ParentId == allPermissions[j].Id) {
                return true;
            }
        }
    }
    return false;
}

function userQueueMember(userId) {
    if (!sosData.queue.id) {
        return false;
    }

    var q = "SELECT Id FROM GroupMember "
    	+ "WHERE GroupId  = '" + escapeSoql(sosData.queue.id) + "' AND "
    	+ "UserOrGroupId  = '" + escapeSoql(userId) + "'";
    var records = soqlCall(q);

    if (!records.length) {
        return false;
    }

    return true;
}

function setupUser() {
    var userId = $("#setup-user-list option:selected").val();

    if (!userId || userId == 0) {
        alert('No user selected.');
        return;
    }

    $('.check-user').show();

    var addLicenseResult = assignLicense();
    setupUserResult(addLicenseResult, 'license-assigned');

    var enableServiceCloudResult = enableServiceCloud();
  	setupUserResult(enableServiceCloudResult, 'service-cloud');

    var addToQueueResult = addUserToQueue();
    setupUserResult(addToQueueResult, 'queue-member');

    var addToPermissionSetResult = addUserToPermissionSet();
    setupUserResult(addToPermissionSetResult, 'permission-set-assigned');
    
    $('#enable-app').text('Update App');
}

function setupUserResult(resultData, id) {
    var status = $('#'+id);
    $('#'+id+'-info').text('- '+resultData.msg);

    if (resultData.success) {
        status.text('PASS').addClass('pass').removeClass('fail');
    } else {
        status.text('FAIL').addClass('fail').removeClass('pass');
    }
}

$('#la-frame').load(function() {
    var laHostname = createLAHostname();

    if (laHostname) {
        $('.la-info').hide();
        $('#la-hostname').text(laHostname);
    }
});

function createLAHostname() {

    var frameContents = getFrameContents('la-frame');

    //if they have access to the page
    if (frameContents) {
        var fullUrl = frameContents.find('input[readonly=readonly]');
        if (fullUrl.length) {
            return fullUrl[0].value.replace('https://','').replace('/chat/rest/','');
        }
    }

    var currentHostname = window.location.hostname;

    if (currentHostname.indexOf('gs0.') !== -1) {
    	return 'd.la.gus.salesforce.com';

    } else if (currentHostname.indexOf('na1-blitz03.') !== -1) {
 		return 'd.la-blitz04.soma.salesforce.com';

    }  else if (currentHostname.indexOf('na1-blitz02.') !== -1) {
 		return 'd.la-blitz03.soma.salesforce.com';

    }  else if (currentHostname.indexOf('na1-blitz04.') !== -1) {
 		return 'd.la-blitz01.soma.salesforce.com';

    } else if (currentHostname.indexOf('na1.') !== -1 ||
               currentHostname.indexOf('na5.') !== -1 ||
               currentHostname.indexOf('na6.') !== -1) {
 		return 'd.la1s1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs1.') !== -1 ||
               currentHostname.indexOf('cs3.') !== -1 ||
               currentHostname.indexOf('cs12.') !== -1) {
 		return 'd.la1cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na0.') !== -1 ||
               currentHostname.indexOf('na3.') !== -1) {
 		return 'd.la1a1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs2.') !== -1 ||
               currentHostname.indexOf('cs4.') !== -1 ||
               currentHostname.indexOf('cs13.') !== -1) {
 		return 'd.la2cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na8.') !== -1 ||
               currentHostname.indexOf('na9.') !== -1 ||
               currentHostname.indexOf('na10.') !== -1 ||
               currentHostname.indexOf('eu1.') !== -1) {
 		return 'd.la1c1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs8.') !== -1) {
 		return 'd.la5cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs7.') !== -1 ||
               currentHostname.indexOf('cs14.') !== -1) {
 		return 'd.la7cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na2.') !== -1 ||
               currentHostname.indexOf('na15.') !== -1) {
 		return 'd.la2c1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs15.') !== -1 ||
               currentHostname.indexOf('cs16.') !== -1 ||
               currentHostname.indexOf('cs19.') !== -1) {
 		return 'd.la2c1cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na19.') !== -1) {
 		return 'd.la3-c1-chi.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs23.') !== -1) {
 		return 'd.la3-c1cs-chi.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs24.') !== -1) {
 		return 'd.la3-c2cs-chi.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na7.') !== -1 ||
               currentHostname.indexOf('na11.') !== -1 ||
               currentHostname.indexOf('na12.') !== -1 ||
               currentHostname.indexOf('na14.') !== -1) {
 		return 'd.la1w1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs10.') !== -1) {
 		return 'd.la6cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs9.') !== -1 ||
               currentHostname.indexOf('cs11.') !== -1) {
 		return 'd.la8cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na4.') !== -1 ||
               currentHostname.indexOf('eu2.') !== -1) {
 		return 'd.la2w1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs17.') !== -1 ||
               currentHostname.indexOf('cs18.') !== -1 ||
               currentHostname.indexOf('cs20.') !== -1) {
 		return 'd.la2w1cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na16.') !== -1 ||
               currentHostname.indexOf('eu3.') !== -1 ||
               currentHostname.indexOf('eu4.') !== -1 ||
               currentHostname.indexOf('eu0.') !== -1) {
 		return 'd.la2w2.salesforceliveagent.com';

    } else if (currentHostname.indexOf('na17.') !== -1) {
 		return 'd.la3-c1-was.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs21.') !== -1) {
 		return 'd.la3-c1cs-was.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs22.') !== -1) {
 		return 'd.la3-c2cs-was.salesforceliveagent.com';

    } else if (currentHostname.indexOf('ap0.') !== -1 ||
               currentHostname.indexOf('ap1.') !== -1) {
 		return 'd.la1t1.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs5.') !== -1) {
 		return 'd.la9cs.salesforceliveagent.com';

    } else if (currentHostname.indexOf('cs6.') !== -1) {
 		return 'd.la10cs.salesforceliveagent.com';
    }

	return false;
}

function soqlCall(query) {
    var queryResult = sforce.connection.query(query);
    return queryResult.getArray('records');
}

function getFrameContents(frameId) {
    var contents;

    try {
    	contents = $('#'+frameId).contents();
    } catch(e) {}

    return contents;
}

//ON events
$('.previousButton').click(function() {
    previousStep();
});

$('.nextButton').click(function() {
    nextStep();
});

$('#check-again').click(function() {
    verifySetup();
});

$('#find-users-button').click(function() {
    showUsers();
});

$('#setup-user-button').click(function() {
    setupUser();
});

$('#clear-search-button').click(function() {
    clearSearch();
});

$('#check-org').click(step1Reset);

$('#create-service-channel').click(createSC);
