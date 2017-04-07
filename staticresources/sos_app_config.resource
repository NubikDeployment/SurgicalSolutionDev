$(function() {
    $('#app-frame').load(function() {
        appPageLoaded();
    });

    $('#enable-app').click(function() {
        enableAppConfig();
    });

    $('#select-app').change(function() {
        $('#app-result').hide();
    });

    $('.show-app-manual').click(function() {
        manualApp();
    });
});

var appConfigTimer;

function enableAppConfig() {
    var editUrl = $("#select-app option:selected").val();

    if (editUrl == 0) {
        alert('App not selected');
        return;
    }

    $('#app-frame').attr('src', editUrl);

    //startAppTimer();
    $('#enable-app').text('Updating...');

    appConfigTimer = setTimeout(function() {
        $('#app-timeout').show();
    },10000);
}

var appUpdateMsg = {};
var modifyApp = {};

function appPageLoaded() {
    $('#app-manual').hide();
    $('#app-auto').show();
    
    var frameContents = getFrameContents('app-frame');

    if (!frameContents) {
        //page is not loaded from salesforce.com, therefore the frame is cross domain
        manualApp();
        return;
    }

    var isAppsPage = frameContents.find('input[name="quickStart"]').length;

    if (isAppsPage) {
        var appsTable = $(frameContents.find('table.list')[0]);
        var consoleRows = appsTable.find('tr td:nth-child(5) img[alt="Checked"]').parent().parent();

        if (!$('#select-app option').length) {

            var selectBox = $('#select-app');

            buildOption(selectBox, 0, '-- SELECT APP --');

            for (var i = 0; i < consoleRows.length; i++) {
                var thisRow = $(consoleRows[i]).find('th a');
                var appName = thisRow.text();

                var appId = thisRow.attr('href').replace('/','');

                var appLink = '/'+ appId + '/e?retURL=%2F' + appId;

                buildOption(selectBox, appLink, appName);
            }
        }
        return;
    }

    var whitelistTextarea = frameContents.find('#domain_whitelist');

    if (whitelistTextarea.length && !appUpdateMsg.whitelist) {
        var spOption = frameContents.find('#sd_components_duel_select_0 option:contains("Omni-Channel")');
        var sosOption = frameContents.find('#sd_components_duel_select_0 option:contains("SOS")');
        
        if (sosOption.length == 0) {
            var sosOptionSelected = frameContents.find('#sd_components_duel_select_1 option:contains("SOS")');
            if (sosOptionSelected.length == 0) {
            	alert('Unable to add the SOS widget to your console app, the user you are currently logged in as does not have SOS permissions.  Please return to Step 2 and add the currently logged in user as a SOS user to grant the needed permissions');
            	$('#enable-app').text('Unable to Update App');
                clearTimeout(appConfigTimer);
            	return;
            }
        }
        
        var reportsOption = frameContents.find('#duel_select_0 option:contains("SOS Reports*")');

        frameContents.find('#sd_components_duel_select_1 option:contains("--None--")').remove();

        appUpdateMsg.widget = 'Already Enabled';
        appUpdateMsg.reports = 'Already Enabled';
        
        if (spOption.length) {
            //not selected
            sosMoveOption(spOption, '#sd_components_duel_select_1', frameContents);
            appUpdateMsg.widget = 'Added';
        }

        if (sosOption.length) {
        	//not selected
            sosMoveOption(sosOption, '#sd_components_duel_select_1', frameContents);
            appUpdateMsg.widget = 'Added';
        }

        if (reportsOption.length) {
            sosMoveOption(reportsOption, '#duel_select_1', frameContents);
            appUpdateMsg.reports = 'Added';
        }

        var whitelistString = 'salesforceliveagent.com,salesforce.com,sos-api-stg.goinstant.org,goinstant.net';
        var currentWhitelist = whitelistTextarea.val();

        if (currentWhitelist.indexOf(whitelistString) == -1) {
            if (!currentWhitelist) {
                whitelistTextarea.val(whitelistString);
            } else {
                whitelistTextarea.val(currentWhitelist +','+ whitelistString);
            }

            appUpdateMsg.whitelist = 'Updated';
        } else {
            appUpdateMsg.whitelist = 'Already Set';
        }

        //check alignment is set
        var currentAlignment = frameContents.find("#sd_components_just option:selected").val();
        if (!currentAlignment) {
            frameContents.find("#sd_components_just").val("0");
            frameContents.find("#sd_components_just").attr('disabled', false);
        }

        $(frameContents.find('input[name="save"]')[0]).trigger('click');

        return;
    }

    var updateSavedPage = frameContents.find('a:contains("Back to List: Custom Apps")').length;

    if (updateSavedPage) {
    	$('#app-result').show();
        clearTimeout(appConfigTimer);
        $('#app-timeout').hide();

        displayResult({msg: appUpdateMsg.whitelist, success:true}, 'whitelist');
        displayResult({msg: appUpdateMsg.widget, success:true}, 'widget');
        displayResult({msg: appUpdateMsg.reports, success:true}, 'reports');

        appUpdateMsg = {};

        clearInterval(modifyApp.timer);
        $('#enable-app').text('Update App');
        $('#app-frame').attr('src', '/02u');

        return;
    }

    console.log('ERROR - Unknow page in app frame')
    //manualApp();
}

function sosMoveOption(oldOption, locationId, frameContents) {
        console.log('\n\nop ', oldOption);
    var optionId = oldOption.val();
    var optionName = oldOption.text();
    oldOption.remove();
    buildOption(frameContents.find(locationId), optionId, optionName);
}

function manualApp() {
    $('#app-auto').hide();
    $('#app-manual').show();
}
