/*
completed - Start Time not equal to "" AND End Time not equal to ""
abandoned - Start Time equals "" AND End Time not equal to ""
requested - End Time not equal to "" (could also do in queue)

duration - Session Duration not equal to ""
wait time - Wait Time not equal to ""
*/

function getSosStats() {
    $("#show-stats").prop("disabled",true);

    showingSessions = {abandoned: false, completed: false};

    var selectedOption = $("#date-range option:selected");
    $('.refresh-link').show();

    var dateRange = selectedOption.val();

    $('#date-range-title').text('SOS Stats For '+ selectedOption.text());

    var where = '';

    if (dateRange != 'all') {
        where = ' AND ' + dateRange;
    }

    var q = 'SELECT '+
        'Contact.Name,'+
        'Contact.Id,'+
        'CreatedDate,'+
        'EndTime,'+
        'Id,'+
        'OwnerId,'+
        'SessionDuration,'+
        'StartTime,'+
        'CaseId,'+
        'WaitDuration '+
        'FROM SOSSession '+
        'WHERE EndTime != Null' + where +
        ' ORDER BY CreatedDate DESC';

    var allSessions = soqlCall(q);

    var requestedCount = allSessions.length;
    var completedSessions = [];
    var abandonedSessions = [];
    var completedWaitDurtaionBreakdown = getDurationBreakdownObject();
    var completedDurtaionBreakdown = getDurationBreakdownObject();
    var sumAbandonedWaitTimes = 0;
    var abandonedWaitDurationBreakdown = getDurationBreakdownObject();

    $('.completed-row,.abandoned-row').remove();

    var sortedDuration = [];
    var sortedWaitDuration = [];
    var sortedAbandonedWaitDuration = [];
    //var numCompletedSession = 0;
    //var numAbandonedSession = 0;
    var maxDuration = 0;
    var maxWait = 0;

    _.each(allSessions, function(row) {
        var rowClass;

        if (row.SessionDuration && row.SessionDuration != 0) {
      //      numCompletedSession++;
            rowClass = 'completed-row';
            completedSessions.push(row);
            var waitCategory = getDurationString(row.WaitDuration);
            completedWaitDurtaionBreakdown[waitCategory]++;

            var durationCategory = getDurationString(row.SessionDuration);
            completedDurtaionBreakdown[durationCategory]++;

            //sortedDuration.push([numCompletedSession, row.SessionDuration * 1000]);
            sortedDuration.push(createScatterChartData(row));
            sortedWaitDuration.push(createScatterChartData(row, true));

        } else {
        //    numAbandonedSession++;
            rowClass = 'abandoned-row';
            abandonedSessions.push(row);
            var abandonedStartTime = Date.parse(row.CreatedDate);
            row.WaitDuration = Math.round((Date.parse(row.EndTime) - abandonedStartTime)/1000);
            sumAbandonedWaitTimes += row.WaitDuration;
            var waitCategory = getDurationString(row.WaitDuration);
            abandonedWaitDurationBreakdown[waitCategory]++;

            sortedAbandonedWaitDuration.push(createScatterChartData(row, true));
        }

        addToTable(row, rowClass);

        if (maxDuration < parseInt(row.SessionDuration)) {
            maxDuration = row.SessionDuration;
        }

        if (maxWait < parseInt(row.WaitDuration)) {
            maxWait = row.WaitDuration;
        }
    });

    var avgAbandonedWaitTime = sumAbandonedWaitTimes / abandonedSessions.length;

    q = 'SELECT AVG(SessionDuration),AVG(WaitDuration) FROM SOSSession WHERE WaitDuration != Null' + where;
    results = soqlCall(q)

    var avgDuration = results[0].expr0;
    var avgWaitTime = results[0].expr1;

    $('#duration').text(timeToString(avgDuration * 1000));
    $('#wait-time').text(timeToString(avgWaitTime * 1000));
    $('#abandoned-wait-time').text(timeToString(avgAbandonedWaitTime * 1000));
    $('#abandoned').text(abandonedSessions.length);
    $('#completed').text(completedSessions.length);
    $('#requested').text(requestedCount);

    var completedAbandonedData = [
        ['Completed', completedSessions.length],
        ['Abandoned', abandonedSessions.length]
    ];
    createPieChart(requestedCount +' Total Sessions', completedAbandonedData);

    var completedWaitTimeData = {
        data: _.pairs(completedWaitDurtaionBreakdown),
        name: 'Completed',
        color: sfdcColors.blue,
    };

    var abandonedWaitTimeData = {
        data: _.pairs(abandonedWaitDurationBreakdown),
        name: 'Abandoned',
        color: sfdcColors.red,
    };

    var sessionDurationData = {
        data: _.pairs(completedDurtaionBreakdown),
        name: 'Completed Sessions',
        color: sfdcColors.blue,
    };

    createTimeBreakdownChart('abandoned-wait-time-chart', 'Wait Time Breakdown', _.keys(abandonedWaitDurationBreakdown), completedWaitTimeData, abandonedWaitTimeData);
    createTimeBreakdownChart('completed-duration-chart', 'Session Duration Breakdown', _.keys(completedDurtaionBreakdown), sessionDurationData);

    var durationScatterData = {
        name: 'Completed',
        color: sfdcColors.blue2,
        data: sortedDuration
    };

    var avgDurationData = {
        name: 'Duration',
        value: avgDuration * 1000
    };

    createScatterChart('duration-scatter-chart', "Session Duration", maxDuration, durationScatterData, avgDurationData);

    var waitScatterData = {
        name: 'Completed',
        color: sfdcColors.blue2,
        data: sortedWaitDuration
    };

    var avgWaitData = {
        name: 'Completed',
        value: avgWaitTime * 1000
    };

    var abandonedScatterData = {
        name: 'Abandoned',
        color: sfdcColors.red2,
        data: sortedAbandonedWaitDuration
    };

    var avgAbandonedData = {
        name: 'Abandoned',
        value: avgAbandonedWaitTime * 1000
    };

    createScatterChart('wait-scatter-chart', "Wait Duration", maxWait, waitScatterData, avgWaitData, abandonedScatterData, avgAbandonedData);

    toggleCompletedSessions();
    toggleAbandonedSessions();
    $("#show-stats").prop("disabled",false);
}

function createScatterChartData(row, useWait) {
    var chartData = {
        x: Date.parse(row.CreatedDate),
        id: row.Id,
        contact: 'UNKNOWN',
        case: row.CaseId
    };

    if (row.Contact) {
        chartData.contact = row.Contact.Name;
    }

    if (useWait) {
        chartData.y = row.WaitDuration * 1000;
    } else {
        chartData.y = row.SessionDuration * 1000;
    }

    return chartData;
}

function createTimeBreakdownChart(divId, title, keys, data1, data2) {
    var chartData = {
        credits: {
          enabled: false
        },
        chart: {
            type: 'column',
            style: {
              fontFamily: 'Helvetica Neue, Helvetica, Arial, sans-serif'
            }
        },
        title: {text:'<strong>'+title+'</strong>'},
        xAxis: {
            categories: keys,
            title: {
                text:'Duration',
                style: {
                    'font-style': 'italic'
                }
            },
            labels: {
                rotation: -45
            }
        },
        series: [
            data1
        ],
        yAxis: {
            allowDecimals: false,
            title: {
                text: '# of Sessions',
                style: {
                    'font-style': 'italic'
                }
            }
        },
        tooltip: {
            headerFormat: '' //removes the time frame from the tooltip
        }
    };

    if (data2) {
        chartData.series.push(data2);
    }

    $('#'+divId).highcharts(chartData).addClass('add-border');
}

function plotLineMouseover(event) {
    $(event.srcElement.offsetParent).find('.plot-line').stop().animate({opacity:1}, 0);
    $(event.srcElement.offsetParent).find('.plot-line').show();
}

function plotLineMouseout(event) {
    $(event.srcElement.offsetParent).find('.plot-line').fadeOut(2500);
}

function createScatterChart(divId, title, max, data, avg, data2, avg2) {
    var yAxisLabel;
    if (parseInt(max) > 2700) {
        yAxisLabel = '{value:%Hh %Mm}'
    } else {
        yAxisLabel = '{value:%Mm}'
    }

    var chartData = {
        credits: {
          enabled: false
        },
        chart: {
            type: 'scatter',
            zoomType: 'xy',
            style: {
              fontFamily: 'Helvetica Neue, Helvetica, Arial, sans-serif'
            }
        },
        title: {text:'<strong>'+title+'</strong>'},
        subtitle: {
            text: "Ordered By Date"
        },
        xAxis: {
            type: 'datetime',
            title: {
                enabled: true,
                text: 'Date',
                style: {
                    'font-style': 'italic'
                }
            },
            startOnTick: true,
            endOnTick: true,
            showLastLabel: true,
            floor: 0,
            labels: {
                format: '{value:%b %d}'
            }

        },
        yAxis: {
            title: {
                text: 'Duration',
                style: {
                    'font-style': 'italic'
                }
            },
            showFirstLabel: false,
            floor: 0,
            type: 'datetime',
            labels: {
                //format: yAxisLabel
                formatter: function() {return timeToString(this.value, true)}
            },
            plotLines: [{
                color: sfdcColors.blue,
                width: 2,
                value: avg.value, // Need to set this probably as a var.
                label: {
                    text: '<span class="hideit bold plot-line">'+avg.name+' Avg: ' + timeToString(avg.value) +'</span>',
                    align: 'right',
                    x: -140,
                    useHTML: true,

                },
                events: {
                    mouseover: plotLineMouseover,
                    mouseout: plotLineMouseout
                }
            }]
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
           // x: 100,
           // y: 55,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
            borderWidth: 1
        },
        plotOptions: {
            series: {
                turboThreshold: 0
            },
            scatter: {
                //lineWidth: '1px',
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                }
            }
        },
        series: [data],
        tooltip: {
            formatter: function() {
                var caseId = this.point.case || 'NONE';
                return '<strong>Contact:</strong> '+this.point.contact +
                    '<br/><strong>Id:</strong> '+this.point.id+
                    '<br/><strong>Case:</strong> '+caseId+
                    '<br/><strong>Duration:</strong> '+timeToString(this.y);
            }
        }
    };

    if (data2) {
        chartData.series.push(data2);
    }

    if (avg2) {

        var plotLineData = {
            color: sfdcColors.red,
            width: 2,
            value: avg2.value, // Need to set this probably as a var.
            label: {
                text: '<span class="hideit bold plot-line">'+avg2.name+' Avg: ' + timeToString(avg2.value) +'</span>',
                // align: 'right',
                //x: -0,
                useHTML: true,

            },
            events: {
                mouseover: plotLineMouseover,
                mouseout: plotLineMouseout
            }
        };

        chartData.yAxis.plotLines.push(plotLineData);
    }

    $('#'+divId).highcharts(chartData).addClass('add-border');
}

function getDurationBreakdownObject() {
    return {
        '<15s': 0,
        '16s-30s': 0,
        '30s-60s': 0,
        '1m-2m': 0,
        '2m-4m': 0,
        '4m-6m': 0,
        '6m-8m': 0,
        '8m-10m': 0,
        '>10m': 0
    };
}

function getDurationString(waitDuration) {
    if (waitDuration < 15) {
        return '<15s';
    } else if (waitDuration < 31) {
        return '16s-30s';
    } else if (waitDuration < 61) {
        return '30s-60s';
    } else if (waitDuration < 121) {
        return '1m-2m';
    } else if (waitDuration < 241) {
        return '2m-4m';
    } else if (waitDuration < 361) {
        return '4m-6m';
    } else if (waitDuration < 481) {
        return '6m-8m';
    } else if (waitDuration < 601) {
        return '8m-10m';
    }

    return '>10m';
}

function toggleCompletedSessions(e) {
    if (e) e.preventDefault();
    showHideSessions('completed');
}

function toggleAbandonedSessions(e) {
    if (e) e.preventDefault();
    showHideSessions('abandoned');
}

//on events
$(function() {
    setAllAgents();

    $('#show-stats').click(function() {
        getSosStats();
        $("#data-tables").show();
    });

    $('#toggle-completed').click(toggleCompletedSessions);
    $('#toggle-abandoned').click(toggleAbandonedSessions)

    getSosStats();
    $("#data-tables").show();
})
