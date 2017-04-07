$(function() {

    var firebaseRef = new Firebase("https://salesforce-sos.firebaseio.com/");
    window.fb = {};
    var hasNickname = false;
    var uuid;
    sosData.demoData;
    sosData.orgData;
    var newDemoId;
    checkForExistingEmail();
    getAllDeployments();

    function checkForExistingEmail() {
        if (hashEmail()) {
            loadSettings();
        }
    }

    function createRefs() {
        if (fb.deploys) {
            fb.deploys.off();
            fb.demos.off();
        }

        fb.user = firebaseRef.child(hashEmail());
        fb.deploys = fb.user.child('deployments');
        fb.demos = fb.user.child('demos');
    }

    function watchEverything() {

        fb.deploys.on('child_added', function(snapshot) {
            if (!sosData.orgdata || !sosData.orgData[snapshot.name()]) {
                var newDeployVal = snapshot.val();
                if (sosData.selectedDeployId == newDeployVal.deploymentId) {
                    $('#org-nickname').val(newDeployVal.name);
                }

                refreshStoredOrgs();
            }
        });

        fb.demos.on('child_added', function(snapshot) {
            if (!sosData.demoData[snapshot.name()]) {
                refreshDemoData();
            }
        });

        fb.deploys.on('child_removed', function(snapshot) {
            var delVal = snapshot.val();
            var orgMatch = sosData.orgId == delVal.orgId;
            var deployMatch = sosData.selectedDeployId == delVal.deploymentId;

            if (orgMatch && deployMatch) {
                clearCurrentOrg();
            }

            refreshStoredOrgs();
        });

        fb.demos.on('child_removed', function() {
            refreshDemoData();
        });

        fb.deploys.on('child_changed', function() {
            refreshStoredOrgs();
        });

        fb.demos.on('child_changed', function() {
            refreshDemoData();
        });
    }

    function watchOrgNickname() {
        fb.thisOrg.child('name').off();
        fb.thisOrg.child('name').on('value', function(snapshot) {
            $('#org-nickname').val(snapshot.val());
        });
    }

    function loadSettings() {
        if (!hashEmail()) {
            alert('You must enter an email to load or store settings.');
            return;
        }

        $('.demo-input').val('');
        uuid = false;
        fb.thisOrg = false;
        hasNickname = false;
        sosData.orgData = false;
        sosData.demoData = false;

        createRefs();

        sf1Check(function() {
            fb.user.once('value', function(snapshot) {
                var currentSettings = snapshot.val();

                if (currentSettings) {
                    sosData.demoData = currentSettings.demos;
                    sosData.orgData = currentSettings.deployments;
                }

                displayStoredDemos();
                displayStoredOrgs();
                watchEverything();

                $('.stored-settings').show();

                //reset selected deployment
                $('#deployment-list').val('0');
                deploySelected();
            });
        });
    }

    function storeCurrentOrg(nickname) {
        if (!sosData.selectedDeployId) {
            alert('should not get here');//kirk
            return;
        }

        if(!hashEmail()) {
            alert('You must enter an email to load or store settings.');
            return;
        }

        var laHostname = createLAHostname() || 'unknown';

        var orgInfo = {
            orgId: sosData.orgId,
            liveAgentPod: laHostname,
            deploymentId: sosData.selectedDeployId,
            name: nickname
        };

        if (uuid && sosData.orgData[uuid]) {
            //Org data exists, update existing org
            fb.thisOrg.set(orgInfo);
        } else {
            //new org, push new data
            fb.thisOrg = fb.deploys.push(orgInfo, function() {
                refreshStoredOrgs();
            });
            uuid = fb.thisOrg.name();
            displayNotify('notify-info', 'New org data saved');
        }
    }

    function displayStoredDemos() {
        var demoSelect = $('#stored-demos');
        demoSelect.empty();

        buildOption(demoSelect, 0, '-- NEW DEMO --');

        if (sosData.demoData) {
            for (var id in sosData.demoData) {
                var displayName = sosData.demoData[id].name || sosData.demoData[id].url;
                buildOption(demoSelect, id, displayName, id == newDemoId);
            }
        }
    }

    function saveNickname() {

        if (!sosData.selectedDeployId || sosData.selectedDeployId == 0) {
            alert('You must select a deployment before saving the org.');
            displayNotify('nickname-info', 'NOT SAVED - Select deployment above');
            return;
        }

        var newNickname = $('#org-nickname').val();
        if (!newNickname) {
            alert('Please enter a nickname for the org.');
            displayNotify('nickname-info', 'NOT SAVED - Enter a nickname');

            return;
        }

        if (hasNickname) {
            if (!confirm('Do you want to change the org nickname?')) {
                return;
            }
            displayNotify('nickname-info', 'Org nickname updated');

        } else {
            displayNotify('nickname-info', 'Org nickname saved');
        }

        hasNickname = true;
        storeCurrentOrg(newNickname);
        watchOrgNickname();
    }

    function saveDemo() {
        var id = $("#stored-demos option:selected").val();

        var demoName = $('#demo-nickname').val();
        var newDemo = {
            url: $('#demo-url').val(),
            email: $('#demo-email').val()
        };

        if (demoName) {
            newDemo.name = demoName;
        }

        if (!newDemo.url) {
            alert('A URL must be provided.');
            return;
        } else if (newDemo.url.indexOf('http') !== 0) {
            alert('Invalid URL provided (Example: http://salesforce.com)');
            return;
        }

        if (!newDemo.email) {
            alert('An email must be provided.');
            return;
        } else if (!validEmail(newDemo.email)) {
            alert('Email provided does not exist in contacts.');
            return;
        }

        if (id == 0) {
        	var newDemoRef = fb.demos.push();
            newDemoRef.set(newDemo);
            newDemoId = newDemoRef.name();

            refreshDemoData();
            displayNotify('demo-info', 'New demo saved');

        } else {
            if (confirm('Do you want to overwrite the existing demo?')) {
            	fb.demos.child(id).set(newDemo);
                displayNotify('demo-info', 'Demo updated');
                refreshDemoData();
            }
        }
    }

    function showSelectedDemo() {
        var id = $("#stored-demos option:selected").val();
		newDemoId = id;
        var disabled = id == 'salesforce1';
        if (id != 0) {
            $('#demo-nickname').val(sosData.demoData[id].name).prop('disabled', disabled);
            $('#demo-url').val(sosData.demoData[id].url).prop('disabled', disabled);
            $('#demo-email').val(sosData.demoData[id].email);
        } else {
            $('.demo-input').val('').prop('disabled', false);
        }
    }

    function deleteDemo() {
        var id = $("#stored-demos option:selected").val();

        if (id == 0) {
            alert('No demo selected');
            return;
        }

        if (id == 'salesforce1') {
            alert('Can not delete salesforce1 demo');
            return;
        }

        if (confirm("Are you sure you want to delete this demo?")) {
            fb.demos.child(id).remove(refreshDemoData);
            $('.demo-input').val('');
            displayNotify('demo-info', 'Demo data deleted');
        }
    }

    function refreshDemoData() {
        fb.demos.once('value', function(snapshot) {
            sosData.demoData = snapshot.val();
            displayStoredDemos();
            newDemoId = false;
            showSelectedDemo();
        });
    }

    function validEmail(email) {
        var query = "SELECT Id FROM Contact WHERE Email  = '" + escapeSoql(email) + "'";
        var queryResult = sforce.connection.query(query);
    	return !!queryResult.getArray('records').length;
    }

    function refreshStoredOrgs() {
        fb.deploys.once('value', function(snapshot) {
            sosData.orgData = snapshot.val();
            displayStoredOrgs();
        });
    }

    function displayStoredOrgs() {
        var orgSelect = $('#stored-orgs');
        orgSelect.empty();

        buildOption(orgSelect, 0, '-- SELECT ORG --');

        if (sosData.orgData) {
            for (var id in sosData.orgData) {
                var displayName = sosData.orgData[id].name || sosData.orgData[id].orgId;
                buildOption(orgSelect, id, displayName);
            }
        }

        showSelectedOrg();
    }

    function showSelectedOrg() {
        var id = $("#stored-orgs option:selected").val();
        var orgInfo = $('.org-info');

        if (id == 0) {
            orgInfo.hide();
            return;
        }

        orgInfo.css('display','inline-block');
        $('#selected-org-id').text(sosData.orgData[id].orgId);
        $('#selected-deploy-id').text(sosData.orgData[id].deploymentId);
        $('#selected-la-hostname').text(sosData.orgData[id].liveAgentPod);
    }

    function deleteOrg() {
        var id = $("#stored-orgs option:selected").val();

        if (id == 0) {
            alert('No org selected');
            return;
        }

        if (confirm('Delete this org?')) {
            fb.deploys.child(id).remove(refreshStoredOrgs);
            displayNotify('org-notify', 'Org data deleted');

            if (id == uuid) {
                clearCurrentOrg();
            }
        }
    }

    function clearCurrentOrg() {
        uuid = false;
        hasNickname = false;
        fb.thisOrg = false;
        $('#org-nickname').val('');
    }

    function sf1Check(cb) {
        var sf1Ref = fb.demos.child('salesforce1');

        sf1Ref.once('value', function(snapshot) {
            if (!snapshot.val()) {
                displayNotify('email-info', 'Email saved');
                var sf1Val = {
                    name: 'salesforce1',
                    email: 'lauren@example.com',
                    url: 'http://ap1.salesforce.com/one/one.app'
                };

                sf1Ref.set(sf1Val, cb);
            } else {
                displayNotify('email-info', 'Existing data loaded');
                cb();
            }
        });
    }

    function saveSfdcEmail() {
        var sfdcEmail = $('#sfdc-email').val().toLowerCase().trim();

        if (!sfdcEmail) {
            //error display by load settings
            return;
        }

        if (sfdcEmail.indexOf('@salesforce.com') == -1) {
            alert('Must be an "@salesforce.com" email.')
            reutrn;
        }

        var customSetting = new sforce.SObject("sos_quick_setup__c");
        customSetting.sfdc_email__c  = sfdcEmail;

        var q = "SELECT Id FROM sos_quick_setup__c WHERE SetupOwnerId = '"+sosData.agentId+"'";
        var records = soqlCall(q);

        var emailId = records.length && records[0].Id

        if (emailId) {
            customSetting.Id = emailId;
            result = sforce.connection.update([customSetting]);
        } else {
            customSetting.SetupOwnerId = sosData.agentId;
            result = sforce.connection.create([customSetting]);
        }
    }

    function deploySelected() {
        var deployEl = $('#deploy_id');

        sosData.selectedDeployId = $("#deployment-list option:selected").val();

        var nickEl = $('#org-nickname');

        if (sosData.selectedDeployId == 0) {
            deployEl.text('Select Deployment Above');
            nickEl.val('');
            return;
        }

        deployEl.text(sosData.selectedDeployId);

        if (sosData.orgData) {

            var selectedOrgInfo = {
                orgId: sosData.orgId,
                deploymentId: sosData.selectedDeployId
            };

            uuid = _.findKey(sosData.orgData, selectedOrgInfo);

            if (uuid) {
                fb.thisOrg = fb.deploys.child(uuid);
            } else {
                fb.thisOrg = null;
            }

            var orgNick = sosData.orgData[uuid] && sosData.orgData[uuid].name;

            if (orgNick) {
                nickEl.val(orgNick);
                hasNickname = true;
                displayNotify('nickname-info', 'Existing deployment, nickname already set');

            } else {
                nickEl.val('');
                hasNickname = false;
                displayNotify('nickname-info', 'Deployment not saved, please set a nickname');

            }
        } else {
            nickEl.val('');
            hasNickname = false;
            fb.thisOrg = null;
            uuid = null;
            displayNotify('nickname-info', 'Deployment not saved, please set a nickname');

        }
    }

    function hashEmail() {
        //should we add verification? since it does not HAVE to be an email
        var sfdcEmail = $('#sfdc-email').val().toLowerCase().trim();
        if (!sfdcEmail) {
            return;
        }

        //https://code.google.com/p/crypto-js/
        return CryptoJS.SHA256(sfdcEmail).toString();
    }

    //on events
    $('#load-settings').click(function() {
        saveSfdcEmail();
        loadSettings();
    });

    $('#save-nickname').click(function() {
        saveNickname();
    });

    $('#save-demo').click(function(){
        saveDemo();
    });

    $('#delete-demo').click(function(){
        deleteDemo();
    });

    $('#stored-demos').change(function() {
       showSelectedDemo();
    });

    $('#stored-orgs').change(function() {
        showSelectedOrg();
    });

    $('#delete-org').click(function() {
        deleteOrg();
    });

    $('#deployment-list').change(function() {
        deploySelected();
    });

    $('#org-nickname').keyup(function (e) {
        if (e.keyCode == 13) {
            // Enter key pressed
            saveNickname();
        }
    });

    $('#sfdc-email').keyup(function (e) {
        if (e.keyCode == 13) {
            // Enter key pressed
            saveSfdcEmail();
            loadSettings();
        }
    });

   	/*
    var counter = 0;
    $('#accordion2').on('show.bs.collapse', function (event) {

        var id = event.target.id;
        if (id == 'collapse_5') {
             counter++;
        if (counter > 1) {
            return;
        }

            $('#collapse_4').collapse('show');
            $('#collapse_5').collapse('hide');

            return false;
        }

       // $('#accordion .in').collapse('hide');
    });
*/
});

function displayNotify(divId, text) {
    var saveInfoEl = $('#' + divId);
    saveInfoEl.stop(false, true);
    saveInfoEl.text(text);
    saveInfoEl.show();

    saveInfoEl.fadeOut(5000);
}

function savedDataCheck() {
    var savedDeploys = _.keys(sosData.orgData).length;
    var savedDemos = _.keys(sosData.demoData).length > 1;
    var collapse5IsOpen = $('#collapse_5').hasClass('in');

    if ((savedDeploys && savedDemos) || collapse5IsOpen) {
        toggleCollapse5();
        return;
    }

    var missing;

    if (!savedDeploys && !savedDemos) {
        missing = 'deployments or demos';
    } else if (!savedDeploys) {
        missing = 'deployments';
    } else if (!savedDemos) {
        missing = 'demos';
    }

    var msg = 'You have not saved any '+missing+', would you like to go to Step 4 and save this data before continuing?'

    if (confirm(msg)) {
        showCollapse4();
        return;
    }

    toggleCollapse5();
}

function showCollapse4() {
    //check if collapse 4 is already open
    if (!$('#collapse_4').hasClass('in')) {
        $('#accordion2 .in').collapse('hide');
        $('#collapse_4').collapse('show');
    }
}

function toggleCollapse5() {
    $('#accordion2 .in').collapse('hide');
    $('#collapse_5').collapse('show');
}
