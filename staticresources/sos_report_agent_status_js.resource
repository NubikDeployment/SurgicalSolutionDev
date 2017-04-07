function agentStatus() {
    $("#refresh-agents").prop("disabled",true);

    var q = 'SELECT User.Name, ServicePresenceStatus.MasterLabel, LastModifiedDate ' +
            'FROM UserServicePresence '+
	        'WHERE IsCurrentState = true ' +
    		'ORDER BY CreatedDate ASC NULLS LAST';    
        
        //'ORDER BY ServicePresenceStatusId ASC NULLS LAST';

    var results = soqlCall(q);

    var template = $("#agent-tpl").text();
    $agentContainer = $('#agent-status tbody');
    $agentContainer.empty();

    var statusTotals = {};

    getTime(function(currentTime) {
        _.each(results, function(agent) {
        		var newElement = $(template);

            var status;
            var statusClass;
            if (agent.ServicePresenceStatus && agent.ServicePresenceStatus.MasterLabel) {
                status = agent.ServicePresenceStatus && agent.ServicePresenceStatus.MasterLabel;
                statusClass = 'is-online';

            } else {
                status = 'Offline';
                statusClass = 'is-offline';

            }

            if (!statusTotals[status]) {
                statusTotals[status] = 0;
            }

            statusTotals[status]++;

            var timeElapsed = '';
            if (currentTime) {
                var lastModified = Date.parse(agent.LastModifiedDate);
				timeElapsed = timeToString(currentTime - lastModified);
            }

            newElement.find('.agent-name').text(agent.User.Name);
            newElement.find('.online-status').text(status).addClass(statusClass);
            newElement.find('.time').text(timeElapsed);

            $agentContainer.append(newElement);
        });

        var pieData = _.pairs(statusTotals);

        createPieChart('Agent Status', pieData);
        $("#refresh-agents").prop("disabled",false);
    });
}

var refreshAgentInterval;
function toggleAutoRefreshAgents() {
    if (refreshAgentInterval) {
        clearInterval(refreshAgentInterval);
        refreshAgentInterval = false;
        $('#auto-refresh-agents').text('OFF');
    } else {
        agentStatus();
        refreshAgentInterval = setInterval(agentStatus,60000);
        $('#auto-refresh-agents').text('ON');
    }
}

//on events
$(function() {
    $('#refresh-agents').click(function() {
        if (refreshAgentInterval) {
            toggleAutoRefreshAgents();
            toggleAutoRefreshAgents();
        } else {
            agentStatus();
        }
    });

    agentStatus();
    $('#auto-refresh-agents').click(toggleAutoRefreshAgents);
})
