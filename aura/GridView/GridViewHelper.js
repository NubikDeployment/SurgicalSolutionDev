({
	getAccountData : function(cmp) {
		var action = cmp.get('c.getAccountData');
        action.setParams({
            "accountId": cmp.get('v.recordId'),
            "accountQueryFields" : cmp.get('v.accountQueryFields'),
            "gColumns" : cmp.get('v.gridColumns')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
           	var data = response.getReturnValue();
            if (cmp.isValid() && state ==='SUCCESS')
            {
                if (data.hasError){
                    cmp.set('v.hasError', true);
					cmp.set('v.errorMessage', data.errorMessage);
					this.hideSpinner(cmp);
                }

                var msg = cmp.find('hierarchyResolvedMsg');
                var accountsTable = cmp.find('accountsTable');
				if (!data.isHierarchyResolved) {
                   	$A.util.addClass(accountsTable, 'hierarchyNotResolved');
                    $A.util.removeClass(msg, 'slds-hidden');
                }else{
                    if (!$A.util.hasClass(msg,'slds-hidden')) $A.util.addClass(msg, 'slds-hidden');
                    if ($A.util.hasClass(accountsTable,'hierarchyNotResolved')) $A.util.removeClass(accountTables, 'hierarchyNotResolved');
                }
                var limit = data.active.order > 15 ? data.active.order * 2 : 40;
                cmp.set('v.limitToShow',limit);
				cmp.set('v.columns',data.columns);
				cmp.set('v.active', data.active);
                cmp.set('v.highlightAccount', cmp.get('v.recordId'));

				cmp.set('v.isCollapseAll', true);
                cmp.set('v.canCreateAccount',data.canCreateAccount);
                cmp.set('v.canEditAccount',data.canEditAccount);

                if(cmp.get('v.accountQueryFields')==''){
                	cmp.set('v.accountQueryFields',data.accountQueryFields);
                }
                if(cmp.get('v.gridColumns')==''){
                	cmp.set('v.gridColumns', data.gColumns);
                }
                this.setHeight(cmp);
                cmp.set('v.allRows', data.rows);
                this.hideSpinner(cmp);
            }else{
				cmp.set('v.hasError', true);
				//TODO Set message
				cmp.set('v.errorMessage', response.error[0].message);
				this.hideSpinner(cmp);
            }
            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action);
	},
    getFromSessionStorage: function(cmp){
		var action = cmp.get('c.getAccount');
        action.setParams({
            "accountId": window.sessionStorage.getItem('editingAccountId'),
            "accountQueryFields" : cmp.get('v.accountQueryFields'),
            "gColumns" : cmp.get('v.gridColumns')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
           	var data = response.getReturnValue();        
            if (cmp.isValid() && state ==='SUCCESS')
            {
                var limitToShow =JSON.parse(sessionStorage.getItem('limitToShow'));
                var columns =JSON.parse(sessionStorage.getItem('columns'));
                var active =JSON.parse(sessionStorage.getItem('active'));
                var allRows =JSON.parse(sessionStorage.getItem('allRows'));
                var isCollapseAll =JSON.parse(sessionStorage.getItem('isCollapseAll'));

                //update edited account
                for(var i=0;i<allRows.length;i++){
                    var r = allRows[i];
                    if (r.id==data.id){
                        r.name = data.name;
                        for (var j=0;j<r.cells.length ;j++){
                            r.cells[j] = data.cells[j];
                        }
                        break;
                    }
                }
                cmp.set('v.limitToShow',limitToShow);
                cmp.set('v.columns',columns);
                cmp.set('v.active', active);
                cmp.set('v.allRows', allRows);
                cmp.set('v.isCollapseAll', isCollapseAll);

                //delete all keys
                sessionStorage.removeItem('limitToShow');
                sessionStorage.removeItem('columns');
                sessionStorage.removeItem('active');
                sessionStorage.removeItem('allRows');
                sessionStorage.removeItem('isCollapseAll');
                sessionStorage.removeItem('isEdited');
                sessionStorage.removeItem('editingAccountId');
                this.setHeight(cmp);
            }

            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action);
	},
    setToSessionStorage : function(cmp){
        if (typeof(sessionStorage)!=undefined)
        {
            sessionStorage.setItem('isEdited',true);
        	var limitToShow = JSON.stringify(cmp.get('v.limitToShow'));
            var columns = JSON.stringify(cmp.get('v.columns'));
            var active = JSON.stringify(cmp.get('v.active'));
            var allRows = JSON.stringify(cmp.get('v.allRows'));
            var isCollapseAll = JSON.stringify(cmp.get('v.isCollapseAll'));

            sessionStorage.setItem('limitToShow',limitToShow);
            sessionStorage.setItem('columns',columns);
            sessionStorage.setItem('active',active);
            sessionStorage.setItem('allRows',allRows);
            sessionStorage.setItem('isCollapseAll',isCollapseAll);
            sessionStorage.setItem('editingAccountId',cmp.get('v.editingAccountId'));
        }
    },

   // All nodes are expanded
	getAll: function(cmp){
		if(true && cmp.get('v.allHierarchy') &&  cmp.get('v.allHierarchy').length > 0) {
			var rows = cmp.get('v.allHierarchy');
			cmp.set('v.allHierarchy', rows); // To trigger the allHierarhcyEvents;
			cmp.set('v.limitToShow', rows.length);
			cmp.set('v.allRows', rows);
			cmp.set('v.isCollapseAll', false);
			this.hideSpinner(cmp);
		} else {
			var rows = cmp.get('v.rows');

			var action = cmp.get('c.getWithExpandeAll');
			action.setParams({"topAccountId": rows[0].id,
	                         "accountQueryFields" : cmp.get('v.accountQueryFields'),
	                          "gColumns" : cmp.get('v.gridColumns')
	                         });
			action.setCallback(this, function(response){
	           	var state = response.getState();
	            if (state ==='SUCCESS') {
	                var data = response.getReturnValue();
	                cmp.set('v.allHierarchy', data.rows);
	                cmp.set('v.limitToShow', data.rows.length);
	                cmp.set('v.allRows', data.rows);
	                cmp.set('v.isCollapseAll', false);
	            }
	            this.hideSpinner(cmp);
			});
			$A.enqueueAction(action);
		}
	},
	// Get children
	getAccountChildren: function(cmp, row) {
		var rows = cmp.get('v.allRows')
		var action = cmp.get('c.getChildren');
		action.setParams({
			"level": row.level,
			"accId": row.id,
            "accountQueryFields" : cmp.get('v.accountQueryFields'),
            "gColumns" : cmp.get('v.gridColumns')
		});
		var that = this;
		action.setCallback(this, function(response){
			var state = response.getState();
      		var data = response.getReturnValue();

		    if (cmp.isValid() && state ==='SUCCESS'){
                that.createBlock(cmp, data, row, rows);
			}
            this.hideSpinner(cmp);
		});
		$A.enqueueAction(action);
	},
    // get Children from the data loaded in memery
    addAccountChildren: function(cmp, row, all) {

        var children = [];

        all.forEach(function(item){
            if(item.parentId == row.id) {
                item.displayingChildren = false;
                children.push(item);
            }
        });
		this.createBlock(cmp, children, row);
    },
	// Set inicial height ( very important for infinity scrolling)
	setHeight: function(component) {
		component.set('v.maxHeight', window.innerHeight);
		var rowHeight  = 38;
		var limit = component.get('v.limitToShow');

		// To prevent bugs with large height resolutions
		if (limit * rowHeight < window.innerHeight) {
			limit = Math.ceil(window.innerHeight / rowHeight + 25);
			component.set('v.limitToShow', limit);
		}
	},

     showOrderedView : function(cmp,helper){
        helper.updateViews(cmp,false,true);
    },
    showTreeView : function(cmp,helper){
    	helper.updateViews(cmp,true,false);
    },

    sort : function(index,sortOrder){

        return function(a,b){
            var valueA = a.cells[index].value == null ? '' : a.cells[index].value;
         	var valueB = b.cells[index].value == null ? '' : b.cells[index].value;

            //check type,implements all types
            if (a.cells[index].type=='INTEGER'){

            	valueA = isNaN(valueA) || valueA == '' ? 0 : parseInt(valueA);
            	valueB = isNaN(valueB) || valueB == '' ? 0 : parseInt(valueB);
            }

         	var result = valueA < valueB ? -1 : (valueA > valueB ? 1 : 0);
         	return result * sortOrder;
        }
	},
    searchByNameFirstTime : function (cmp,helper,term){

		var action = cmp.get('c.getWithExpandeAll');
		action.setParams({"topAccountId": cmp.get('v.rows')[0].id,
                         "accountQueryFields" : cmp.get('v.accountQueryFields'),
                         "gColumns" : cmp.get('v.gridColumns')
                         });
		action.setCallback(this, function(response){

           	var state = response.getState();
            if (state ==='SUCCESS') {
            	var data = response.getReturnValue();
				cmp.set('v.allHierarchy', data.rows);
				cmp.set('v.isCollapseAll', false);
            	var filteredRows = helper.searchByName(cmp.get('v.allHierarchy'),term);
            	cmp.set('v.rows',filteredRows);
            }
			this.hideSpinner(cmp);
		});
		$A.enqueueAction(action);
    },

    searchByName: function (items,term){

        var positions = [];
        var rowsToDisplay = items.filter(function(item,i){
            positions.push(item.id);
            var result = item.name.toUpperCase().indexOf(term.toUpperCase()) >= 0 || i==0;
            item.inSearch = result && i > 0 && term!='';
            item.viewMore = false;
            return result;
        });
        //add additional rows
        //do not include the first row,it is the top parent
        var rowsToDisplayTemp = rowsToDisplay.slice(0);
        for (var i=1; i<rowsToDisplayTemp.length ;i++){
            var parentsToAdd = [];
            var row = rowsToDisplayTemp[i];
            var hasParent = row.parentId !=null && row.parentId!='';
            var parentIndex = positions.indexOf(row.parentId);
            while (hasParent && parentIndex > 0 ){
                var rowToAdd = items[parentIndex];
                if (parentsToAdd.indexOf(rowToAdd)<0 && rowsToDisplay.indexOf(rowToAdd)<0){
                    parentsToAdd.push(rowToAdd);
                }
                parentIndex = positions.indexOf(rowToAdd.parentId);
                hasParent = rowToAdd.parentId !=null && rowToAdd.parentId!='';

                //TODO: add "view more" rows

            }
            for (var j = parentsToAdd.length-1;j >=0 ;j--){
   				rowsToDisplay.unshift(parentsToAdd[j]);
			}
        }
        //order rows
        rowsToDisplay.sort(function(a,b){
         	return a.order < b.order ? -1 : (a.order > b.order ? 1 : 0);
        });

        return rowsToDisplay.length > 1 ? rowsToDisplay : [];
    },

    updateViews: function(cmp,isTreeView,isOrderedView){

        //udpate variables
    	cmp.set('v.treeViewIsVisible',isTreeView);
        cmp.set('v.orderedViewIsVisible',isOrderedView);
        if (isTreeView){

            var headers = cmp.find('treeView-header');
        	for(var i=0; i <= headers.length-1; i++){
        		var item = headers[i];
        		$A.util.removeClass(item, 'col-header-active');
            	$A.util.removeClass(item, 'ascending');
            	$A.util.removeClass(item, 'descending');
        	}
            //reset columns order
        	var columns = cmp.get('v.columns');
        	for(var i=0;i < columns.length;i++){
            	columns[i].sortOrder = 'none';
        	}
        	cmp.set('v.columns',columns);
            cmp.set('v.rows', cmp.get('v.rows')); // This line is to trigger the render again.
        }
	},
    // The next logic is necessary to resolve the nodes to display
    createBlock : function(cmp, data, row, allrows) {

        var rows = ( allrows == undefined ) ? cmp.get('v.allRows') : allrows;
        var block1 = [], block2 = [], block3 = [];
			var numberOfBlock = 1;
			for (var x = 0, y = rows.length; x < y; x++) {

				if (numberOfBlock == 1) {
					block1.push(rows[x])
				}
				if (numberOfBlock == 3) {
					block3.push(rows[x]);
				}
				if (numberOfBlock == 2) {
					block2.push(rows[x]);
					if(rows[x +1] && rows[x +1].level == block1[block1.length -1].level) {
						numberOfBlock = 3;
					}
				}
				if (rows[x].id == row.id) {
					rows[x].displayingChildren = true;
					if (rows[x +1] && rows[x +1].level > rows[x].level) {
						numberOfBlock = 2;
					}else {
						numberOfBlock = 3;
					}
				}
			}
			data.forEach(function(item) {
                item.level = (allrows != undefined ) ? item.level +1 : item.level;
				if (block2[0] && block2[0].id == item.id) {
					block2.forEach(function(i){
						block1.push(i);
					})
				} else {
					block1.push(item);
				}
			});
			block3.forEach(function(item) {
				block1.push(item);
			});

            var limit = cmp.get('v.limitToShow');
            cmp.set('v.limitToShow', limit + data.length);
			cmp.set('v.allRows', block1);
    },
     showSpinner : function(cmp){
        cmp.set("v.spinner", true);
	},

    hideSpinner : function(cmp){
        cmp.set("v.spinner", false);
    },
    scrollToActive: function(cmp){
    	if(cmp.get("v.isDoneRowsRendering") && !cmp.get("v.isDoneRendering")){
       		cmp.set("v.isDoneRendering", true);
            setTimeout($A.getCallback(function(){
                var activeRow = cmp.get('v.active');
                var htmlRow = document.getElementById(activeRow.id);
                if(htmlRow!=null){
                    var scrollTo = htmlRow.offsetTop - (htmlRow.clientHeight*2);
                    if (cmp.isValid()) {
                        var container = cmp.find('gridContainer');
                        container.getElement().scrollTop =scrollTo;
                    } 
                } 
            }),300);
    	}
	}
})