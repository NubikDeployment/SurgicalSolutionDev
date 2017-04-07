({
	doInit : function(cmp, event, helper) {
        helper.showSpinner(cmp);
		helper.getAccountData(cmp);
	},
    selectRow: function(cmp, event, helper) {
        
        var highlightAccount = event.currentTarget.getAttribute('data-row');
        cmp.set('v.highlightAccount', highlightAccount);
    },
    // Hide  children from node
    hideChildren: function(cmp, event, helper) {

    	var row = event.target.value;
        var children = row.childrenIds;
        var rows = cmp.get('v.allRows');
		var block = [];
		var adding = true;
        rows.forEach(function(item){
			if(adding) {
				block.push(item);
			}
			if(!adding && block[block.length-1].level >= item.level) {
				block.push(item);
				adding = true;
			}
            if (item.id == row.id) {
                item.displayingChildren = false;
				adding = false;
            }
        });
        cmp.set('v.allRows', block);
	},
	// get children from server
	displayChildren: function(cmp, event, helper) {
	
        var row = {};
        var level = event.target.getAttribute('data-level');
        var id = event.target.getAttribute('data-id');
		row.id = id;
        row.level = level;
		//var row = event.target.value;
        var allHierarchy = cmp.get('v.allHierarchy');


        if (allHierarchy == undefined || allHierarchy.length == 0) {
            helper.getAccountChildren(cmp, row);
        } else {
            helper.addAccountChildren(cmp, row, allHierarchy);
        }
	},
	// Expande or Collapse all (Collapse is the first view)
	expandCollapse: function(cmp, event, helper) {

        event.stopPropagation();
		var isCollapse = cmp.get('v.isCollapseAll');
        var orderedViewIsVisible = cmp.get('v.orderedViewIsVisible');

        //check if we are in ordered view
        if (orderedViewIsVisible) {
            cmp.set('v.orderedViewIsVisible',false);
            helper.showTreeView(cmp,helper);
            return;
        }

        helper.showSpinner(cmp);
        if (isCollapse)
			helper.getAll(cmp);
        else
        	helper.getAccountData(cmp);

	},
	// Fix Thead and top parent; Load more records
	scrollEvents: function(cmp, event, helper) {
		var translate = cmp.get('v.translate');
		if (isNaN(translate)) {
			translate = 0;
		}
		cmp.set('v.translate', event.target.scrollTop);

        var height = parseInt(event.target.style.height);
        if (!isNaN(height) && height  >= event.target.scrollHeight-event.target.scrollTop)
        {

            // Infinite scroll
			var limit = cmp.get('v.limitToShow');
            var allRows = cmp.get('v.allRows');

            if (limit < allRows.length  ){
				cmp.set('v.limitToShow', limit + 30);
				cmp.set('v.loadingMore', true);

				if (cmp.get('v.orderedViewIsVisible') ){
					allRows = cmp.get('v.allOrderRows');
					setTimeout($A.getCallback(function(){
                        cmp.set('v.allOrderRows', cmp.get('v.allOrderRows'));
						cmp.set('v.allRows', cmp.get('v.allRows'));
                        cmp.set('v.loadingMore',false);

                    }));
				} else {
                    setTimeout($A.getCallback(function(){
                        cmp.set('v.allRows', allRows);
                        cmp.set('v.loadingMore',false);

                    }));
				}
        	}
        }
	},
	// Handler for set Header
	setHeaderBar: function(cmp, event, helper) {

		var appEvent = $A.get("e.accHierarchy:AccountHierarchyItemsEvent");
		var rows = cmp.get('v.rows');
		var active = cmp.get('v.active');
		appEvent.setParams({ "number" : rows.length, "active": active,"canCreateAccount":cmp.get('v.canCreateAccount') });
		appEvent.fire();
	},
	// Set rows to display with the limitToShow, always set allRows
	setRows: function(cmp, event, helper) {
		var rows = cmp.get('v.allRows');
		var limit = cmp.get('v.limitToShow');
        var sliceRows = rows.slice(0,limit)
		cmp.set('v.rows', sliceRows);

		//cmp.set('v.orderedRows', rows.slice(0,limit));

        //this attribute is used to scrolling to the active row after rendering
        if (!cmp.get('v.isDoneRowsRendering')){
            cmp.set('v.isDoneRowsRendering',true);
        }

	},
    setOrderRows: function(cmp, event, helper) {

        cmp.set('v.highlightAccount', cmp.get('v.highlightAccount'));

        var rows = cmp.get('v.allOrderRows');
		var limit = cmp.get('v.limitToShow');
		cmp.set('v.orderedRows', rows.slice(0,limit));


        if (!cmp.get('v.isDoneRowsRendering')){
            cmp.set('v.isDoneRowsRendering',true);
        }
    },
    sortByColumn : function(cmp,event,helper){
        var index = parseInt(event.target.getAttribute('data-index'));
        if (!isNaN(index)) {
            var headers = cmp.find('treeView-header');
            var cmpTarget = headers[index];
            var sortOrder = 0;
            if (!cmp.get('v.orderedViewIsVisible'))
                cmp.set('v.orderedViewIsVisible',true);

            //add style to the th
            for(var i=0; i <= headers.length-1; i++){
                var item = headers[i];
                $A.util.removeClass(item, 'col-header-active');
                $A.util.removeClass(item, 'ascending');
                $A.util.removeClass(item, 'descending');
            }
            $A.util.addClass(cmpTarget, 'col-header-active');


            //set the corresponding order
            var columns = cmp.get('v.columns');
            var column = columns[index];

            if (column.sortOrder =='none' || column.sortOrder =='desc'){
                sortOrder = 1;
                column.sortOrder = 'asc';
                $A.util.removeClass(cmpTarget, 'ascending');
                $A.util.removeClass(cmpTarget, 'descending');
                $A.util.addClass(cmpTarget, 'ascending');
            }
            else{
                sortOrder = -1;
                column.sortOrder = 'desc';
                $A.util.removeClass(cmpTarget, 'ascending');
                $A.util.removeClass(cmpTarget, 'descending');
                $A.util.addClass(cmpTarget, 'descending');
            }

            //update order
            cmp.set('v.columns',columns);

            //order rows
            //var orderedRows = cmp.get('v.orderedRows');
            var all = cmp.get('v.allRows');
            var orderedRows = all.slice(0);
            cmp.set('v.sortOrderColumnIndex',index);
            cmp.set('v.sortOrder',sortOrder);
            var rows = orderedRows.sort(helper.sort(index,sortOrder));
            //cmp.set('v.orderedRows',rows);

            cmp.set('v.allOrderRows', rows);
            helper.showOrderedView(cmp,helper);
        }
	},
    search : function(cmp,event,helper){

        if (cmp.get('orderedViewIsVisible')){
            helper.updateViews(true,false);
        }
        var term = event.getParam('searchTerm');
        var items = cmp.get('v.allHierarchy');

        if (term=='' || term==null){
            //update search items
        	for(var i=0;i<items.length;i++){
          	items[i].inSearch =false;
          }
        	cmp.set('v.allRows',items);
          return;
        }
        if (!cmp.get('v.isFirstSearchDone') && items.length == 0){
            cmp.set('v.isFirstSearchDone',true);
            helper.showSpinner(cmp);
            helper.searchByNameFirstTime(cmp,helper,term);
            return;
        }
    		var result = helper.searchByName(items,term);
				cmp.set('v.isCollapseAll', false);
        cmp.set('v.allRows',result);
    },
    handleEditAccount : function(cmp,event,helper){

      	var accountId = event.getParam('editingAccountId');
        cmp.set('v.editingAccountId',accountId);
        helper.setToSessionStorage(cmp);
    },
    handleSearchMode : function(cmp,event,helper){
        var isSearchMode = $A.util.getBooleanValue(event.getParam('isSearchMode'));
        if (isSearchMode){
            cmp.set('v.highlightPreviousAccount',cmp.get('v.highlightAccount'));
            cmp.set('v.highlightAccount','');
        }else{
            cmp.set('v.highlightAccount',cmp.get('v.highlightPreviousAccount'));
        }

    },
    showToolTip: function(cmp,event,handler){
       	var appEvent = $A.get("e.accHierarchy:OnHoverExpandEvent");
        var isOrderedView = cmp.get('v.orderedViewIsVisible');
        var isCollapseAll = cmp.get('v.isCollapseAll');
        if (isOrderedView){
            var hoverText = 'Return to Hierarchy';
        	var hoverMode = 2;
        }else if(isCollapseAll){
        	var hoverText = 'Expand All';
            var hoverMode = 1;
        }else{
            var hoverText = 'Collapse All';
            var hoverMode = 0;
        }

		appEvent.setParams({ "hoverText" : hoverText, "hoverMode": hoverMode });
		appEvent.fire();
    },
    hideToolTip: function(cmp,event,helper){
        var appEvent = $A.get("e.accHierarchy:OnLeaveExpandEvent");
        appEvent.fire();
    },
	hideError : function(cmp) {
		cmp.set('v.hasError', false);
	}
})