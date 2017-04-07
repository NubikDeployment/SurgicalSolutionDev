function getSosStats() {
    $("#refresh-stats").prop("disabled",true);

    //clear the table
    $('.active-row,.queue-row').remove();

    var q = 'SELECT ' +
        'Contact.Name, ' +
        'CaseId, ' +
        'Id, ' +
        'OwnerId,'+
        'CreatedDate,' +
        'StartTime ' +
        'FROM SOSSession '+
        'WHERE EndTime = Null AND CreatedDate > YESTERDAY';

    var results = soqlCall(q);
    //window.allresults = results;

    var $inQueue = $('#in-queue');
    var $totalWaitTime = $('#total-wait-time');
    var $longestWaitTime = $('#longest-wait-time');
    var $avgWaitTime = $('#avg-wait-time');


    var $active = $('#active');
    var $totalActiveTime = $('#total-active-time');
    var $longestActiveTime = $('#longest-active-time');
    var $avgActiveTime = $('#avg-active-time');

    var $unknownStartStat = $('#unknown-start-stat');
    var $unknownStartValue = $('#unknown-start');

    var $table = $('#table-container');


    if (!results.length) {
        //no active or in queue sessions
        $inQueue.text('0');
        $totalWaitTime.text(timeToString(0));
        $longestWaitTime.text(timeToString(0));
        $avgWaitTime.text(timeToString(0));

        $active.text('0');
        $totalActiveTime.text(timeToString(0));
        $longestActiveTime.text(timeToString(0));
        $avgActiveTime.text(timeToString(0));

        $unknownStartStat.hide();
        $table.hide();

        $("#refresh-stats").prop("disabled",false);

        return;
    }

     $table.show();

    //Find find out which of the sessions are active
    if (results.length) {
        var allIdsString = '(';
        _.each(results,function(row) {
            allIdsString += "'"+row.Id +"',";
        });

        allIdsString = allIdsString.slice(0,-1) + ')';

        q = "SELECT Status, LastModifiedDate, WorkItemId, CreatedDate, RequestDateTime, SpeedToAnswer "+
            "FROM AgentWork "+
            "WHERE "+
            //"(Status = 'Opened' OR Status = 'Closed') AND "+
            "WorkItemId IN " + allIdsString;

        var activeSessions = soqlCall(q);
    }

    getTime(function(currentTime) {
        if (!currentTime) {
            //show error here
            console.log('ERROR GETTING CURRENT TIME');
            return;
        }

        var queueResults = [];
        var allQueueTimes = [];
        var sumQueueTimes = 0;
        var maxQueueTime = 0;
        var avgQueueTime = 0;

        var activeResults = [];
        var allActiveTimes = [];
        var sumActiveTimes = 0;
        var maxActiveTime = 0;
        var avgActiveTime = 0;

        var activeUnknownResults = [];

        var className;

        _.each(results, function(row) {
            var isActive = _.find(activeSessions, function(workRow) {
               return row.Id == workRow.WorkItemId;
            });

            if (!_.isEmpty(isActive)) {
                row.status = isActive.Status;
                row.StartTime = row.StartTime || isActive.LastModifiedDate ;
            }

            if (row.status == 'Opened') {
                //active session, known start time
                className = 'active-row';
                activeResults.push(row);
             
                if (row.status == 'Closed') {
                    //They closed the SOS Session tab but session is still active
                    row.WaitDuration = isActive.SpeedToAnswer;
                    row.SessionDuration = ((currentTime - Date.parse(isActive.RequestDateTime))/1000) - isActive.SpeedToAnswer;
                } else {
                    row.WaitDuration = (Date.parse(row.StartTime) - Date.parse(row.CreatedDate)) / 1000;
                    row.SessionDuration = (currentTime - Date.parse(row.StartTime)) / 1000;
                }
                
                var sessionTime = row.SessionDuration * 1000;

                allActiveTimes.push(sessionTime);
                sumActiveTimes += sessionTime;

                if (sessionTime > maxActiveTime) {
                    maxActiveTime = sessionTime;
                }
            } else if (row.status != 'Closed') {
                className = 'queue-row';
                queueResults.push(row);
                var requestTime = Date.parse(row.CreatedDate);
                var waitTime = currentTime - requestTime;
                row.WaitDuration = waitTime / 1000;
                allQueueTimes.push(waitTime);
                sumQueueTimes += waitTime;

                if (waitTime > maxQueueTime) {
                    maxQueueTime = waitTime;
                }
            }

            if (row.status != 'Closed') {
            	addToTable(row, className);
            }
        });

        $inQueue.text(queueResults.length);
        $totalWaitTime.text(timeToString(sumQueueTimes));
    	$longestWaitTime.text(timeToString(maxQueueTime));
        $avgWaitTime.text(timeToString(sumQueueTimes/queueResults.length));

        $active.text(activeResults.length);
        $totalActiveTime.text(timeToString(sumActiveTimes));
    	$longestActiveTime.text(timeToString(maxActiveTime));
        $avgActiveTime.text(timeToString(sumActiveTimes/activeResults.length));

        if (activeUnknownResults.length) {
            $unknownStartStat.show();
            $unknownStartValue.text(activeUnknownResults.length);
        } else {
            $unknownStartStat.hide();
        }

        $("#refresh-stats").prop("disabled",false);
    });
}

var refreshInterval;
function toggleAutoRefresh() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = false;
        $('#auto-refresh').text('OFF');
    } else {
        getSosStats();
        refreshInterval = setInterval(getSosStats,60000);
        $('#auto-refresh').text('ON');
    }

}

//on events
$(function() {
    setAllAgents();

    $('#refresh-stats').click(function() {
        if (refreshInterval) {
            toggleAutoRefresh();
            toggleAutoRefresh();
        } else {
            getSosStats();
        }
    });

    $('#auto-refresh').click(toggleAutoRefresh);

    getSosStats();
    $('#toggle-queue').show();
    $('#toggle-active').show();
    $('#session-table').show();
    $('#data-tables').show();

})
