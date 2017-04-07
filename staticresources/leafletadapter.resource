function renderMapChart(response, size, div) {
    div.style.height = size[1]+'px';
    div.style.width = size[0]+'px';
    var data = [];
    response.groupingsDown.groupings.forEach(function(e, i, arr) {
        e.groupings.forEach(function(se, si, sarr) {
            data.push([se.label+','+e.label, 
                       response.factMap[se.key+'!T'].aggregates[0].value/ response.factMap['T!T'].aggregates[0].value*100,
                       se.label+','+e.label+' - ' + response.factMap[se.key+'!T'].aggregates[0].label
                      ])
        });
    });
    var geoCodedData = [];
    asyncGeoCode(data, geoCodedData, function(e, lat, long) {
        return [lat, long, e[1], e[2]];
    });                   
    (function drawChartWhenReady() {
        // Draw the map centered on USA, zoomed to the state level
        (geoCodedData.length === data.length) ? drawLeafletMap(L.map(div.id), 4, [33, -95], geoCodedData) : setTimeout(drawChartWhenReady , 500);
    })();
};
