function manualChange() {
    $('#auto-pop-toggle').hide();
    $('#auto-pop-pre-load').hide();
    $('#auto-pop-text').hide();
    $('#auto-pop-manual').show();
    $('#auto-pop .tinytext').hide();
}

function changeLayout(layoutName) {
    var frameContents = getFrameContents('layout-frame');

    frameContents.find('#000000000000000').trigger('click');

    var newLayoutId = frameContents.find('option:contains("'+layoutName+'")').val();

    frameContents.find('#pageLayoutSelector').val(newLayoutId).change();
    frameContents.find('input[name="save"').trigger('click');
}

function layoutPageLoaded() {
    var frameContents = getFrameContents('layout-frame');
    
    if (!frameContents) {
		manualChange();
        return;
    }

    var correctPage = frameContents.find('select').length;

    if (correctPage) {
        checkSelectedLayout();
        return;
    }

    var updatedPage = frameContents.find('input[value="Edit Assignment"]').length

    if (updatedPage) {
        clearTimeout(autoPopTimeout);
        $('#auto-pop-timeout').hide();
        $('#layout-frame').attr('src', '/_ui/common/config/layout2/LayoutMappingUI/e?type=SOSSession&e=1&pageNum=0&');
    	return;
    }

    autoPop.layoutEnabled = 'failed';
    manualChange();
}

function checkSelectedLayout() {
    var frameContents = $('#layout-frame').contents();
    var isLoading = frameContents.find('#loadingDiv').css('display') == 'block';

    if (isLoading) {
        setTimeout(checkSelectedLayout, 500);
        return;
    }

    autoPop.layoutEnabled = !!frameContents.find('td:contains("SOS Auto Pop Case"):not(:contains("Page"))').length;
    checkAutoPopEnabled();
}

function updateAutoPopText() {
    var msg;
    var buttonText;
    var notifyText;
    var enabled = autoPop.layoutEnabled && autoPop.triggerEnabled;

	$('#auto-pop-pre-load').hide();

    if (enabled) {
        msg = 'Auto Case Pop is currently enabled, if you are having issues or no longer want cases to open in a subtab automatically, it can be disabled below (this can take up to a minute).'
        buttonText = 'Disable Custom Page Layout';
        notifyText = 'Auto Case Pop is enabled.'
    } else {
        msg = 'To automatically open a Case and related Contact in a subtab once an Agent has accepted an SOS session, simply press the Update Page Layout button below (this can take up to a minute).'
        buttonText = 'Update Page Layout';
        notifyText = 'Auto Case Pop is disabled.'
    }

    $('#auto-pop-text').text(msg);
    $('#auto-pop-toggle').prop('disabled', false).text(buttonText).show();
    displayNotify('auto-pop-notify', notifyText);

    $('#auto-pop-text').show();
    $('#auto-pop .tinytext').show();
    $('#auto-pop-manual').hide();
}

function checkAutoPopEnabled() {
    if (autoPop.layoutEnabled == 'loading' || autoPop.triggerEnabled == 'loading') {
        return;
    }

    if (autoPop.layoutEnabled == 'failed' || autoPop.triggerEnabled == 'failed') {
        manualChange();
        return;
    }

    updateAutoPopText();

}

var autoPopTimeout;

function toggleAutoPop() {

    autoPopTimeout = setTimeout(function() {
        $('#auto-pop-timeout').show();
    },10000);

    var isEnabled = autoPop.layoutEnabled === true && autoPop.triggerEnabled === true;

    autoPop.layoutEnabled = 'loading';
    autoPop.triggerEnabled = 'loading';
    autoPop.enabled = !isEnabled;

    if (isEnabled) {
        changeLayout('SOS Session Layout');
    } else {
        changeLayout('SOS Auto Pop Case');
    }

    updateTriggerSetting();

    $('#auto-pop-toggle').prop('disabled', true).text('Updating...');
}

function updateTriggerSetting() {
    var q = "SELECT Id FROM SOS_Create_Case__c";
    var records = soqlCall(q);
    var id = records.length && records[0].Id


    var customSetting = new sforce.SObject("SOS_Create_Case__c");
   	customSetting.enabled__c = autoPop.enabled;

    if (id) {
        customSetting.Id = id;
        result = sforce.connection.update([customSetting]);
    } else {
        result = sforce.connection.create([customSetting]);
    }

    if (result && result.length && result[0].getBoolean("success")) {
        autoPop.triggerEnabled = autoPop.enabled;
        checkAutoPopEnabled();
    } else {
        autoPop.triggerEnabled = 'failed';
        manualChange();
    }
}


$(function() {
    var layoutPageTimeout = setTimeout(function() {
        manualChange();
    },10000)

    $('#layout-frame').load(function() {
        clearTimeout(layoutPageTimeout);
        layoutPageLoaded();
    });

    $('#auto-pop-toggle').click(toggleAutoPop);

    $('#show-case-pop-manual').click(manualChange);
});
