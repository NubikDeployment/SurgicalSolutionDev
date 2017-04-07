({
	doInit: function(component, event, helper) {
		// Get current opportunity
		var oppId = component.get("v.oppId");

		var action = component.get("c.getOppById");
		action.setParams({theId : oppId});
		action.setCallback(this, function(response) {
			var resp = response.getReturnValue();
			component.set("v.surgeon",resp.Surgeon__c);
			component.set("v.tech",resp.Owner.Name);
			component.set("v.opp",resp);

			console.log(resp.StageName);
			if(resp.StageName != 'Post-Op')
			{
				component.set("v.showSelect",false);
			}
			else
			{
				component.set("v.showSelect",true);
			}
		});

		$A.enqueueAction(action);

		// Get current preference card
		var pcId = component.get("v.pcId");

		var action2 = component.get("c.getPreferenceCardById");
		action2.setParams({theId : pcId});
		action2.setCallback(this, function(response2) {
			var resp2 = response2.getReturnValue();

			component.set("v.patientPosition",resp2.Patient_Position__c);
			component.set("v.arms",resp2.Arms__c);
			component.set("v.legs",resp2.Legs__c);
			component.set("v.roomSetup",resp2.Room_Setup__c);
			component.set("v.normal",resp2.Normal__c);
			component.set("v.stirrups",resp2.Stirrups__c);
		});

		$A.enqueueAction(action2);

		// Get inventories
		var action3 = component.get("c.getInventories");
		action3.setParams({theId : pcId});
		action3.setCallback(this, function(response3) {
			var resp3 = response3.getReturnValue();
			
			// Temp, key should be fetch automatically
			var items = [];
			items.push({key:'Equipment',value:resp3['Equipment']});
			items.push({key:'Laparoscopes',value:resp3['Laparoscopes']});
			items.push({key:'Instrumentation',value:resp3['Instrumentation']});
			items.push({key:'Disposable',value:resp3['Disposable']});

			component.set("v.allInventories",items);
		});

		$A.enqueueAction(action3);

		window.onload = function(){
			document.getElementById("hiddenElementId").focus();
		}
	},

	checkboxClicked: function (component, event, helper) {
		var checkboxId = event.target.id;
		var lineName = checkboxId.split('-')[1];
		var qtyId = 'qty-'+lineName;
		
		if(document.getElementById(checkboxId).checked)
		{
			//var inputQty = component.find('qty-'+lineName).get('v.value');
			var inputQty = document.getElementById(qtyId).value;
			if(inputQty == 0)
			{
				//component.find('qty-'+lineName).set('v.value',1);
				document.getElementById(qtyId).value = 1;
			}
		}
		else
		{
			//component.find('qty-'+lineName).set('v.value',0);
			document.getElementById(qtyId).value = 0;
		}
	},

	decreaseQty: function (component, event, helper){
		var lineId = event.target.parentNode.parentNode.id;
		if(lineId == undefined || lineId == ''){
			lineId = event.target.parentNode.parentNode.parentNode.id;
		}
		var lineName = lineId.split('-')[1];
		var checkboxId = 'checkbox-'+lineName;

		//var inputQty = component.find('qty-'+lineName).get('v.value');
		var qtyId = 'qty-'+lineName;
		var inputQty = parseInt(document.getElementById(qtyId).value);
		if(inputQty != 0)
		{
			//component.find('qty-'+lineName).set('v.value',inputQty-1);
			document.getElementById(qtyId).value = inputQty-1;
		}

		if(parseInt(document.getElementById(qtyId).value) == 0 && document.getElementById(checkboxId).checked)
		{
			document.getElementById(checkboxId).checked = false;
		}
	},

	increaseQty: function (component, event, helper) {
		//console.log('click');
		var lineId = event.target.parentNode.parentNode.id;
		if(lineId == undefined || lineId == ''){
			lineId = event.target.parentNode.parentNode.parentNode.id;
		}

		var lineName = lineId.split('-')[1];
		var checkboxId = 'checkbox-'+lineName;

		if(!document.getElementById(checkboxId).checked)
		{
			document.getElementById(checkboxId).checked = true;
		}
		
		var qtyId = 'qty-'+lineName;
		//var inputQty = component.find(qtyId).get('v.value');
		var inputQty = document.getElementById(qtyId).value
		document.getElementById(qtyId).value = parseInt(inputQty)+1;
		//component.find('qty-'+lineName).set('v.value',inputQty+1);
	},

	save: function (component, event, helper) {
		alert('Click on save');
	},

	openSection: function (component, event, helper) {
		$A.util.toggleClass(event.target.parentNode.parentNode,'slds-is-open');
	}
})