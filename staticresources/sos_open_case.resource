function escapeSoql (str) {
    return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

$(function() {
    sforce.console.getEnclosingPrimaryTabObjectId(function(result){
        if (!result || !result.success) {
            return;
        }

        var sosSessionId = result.id;

        var query = "SELECT CaseId, OwnerId FROM SOSSession WHERE Id = '" + escapeSoql(sosSessionId) + "'"

        var queryResult = sforce.connection.query(query);
        var record = queryResult.getArray('records');

        if (!record || !record[0]) {
            return;
        }

        var caseId = record[0].CaseId;
        var ownerId = record[0].OwnerId;

        if (!ownerId) {
            console.log('No owner Id, exit early.', record);
            return;
        }

        var caseUpdate = new sforce.SObject("Case");
        caseUpdate.Id = caseId;
        caseUpdate.OwnerId = ownerId;
        result = sforce.connection.update([caseUpdate]);

        if (!result[0].getBoolean("success")) {
            console.log('Unable to set owner', result, caseUpdate);
        }

        sforce.console.getEnclosingPrimaryTabId(function(result){
            if (!result || !result.success) {
                return;
            }

            var query = "SELECT CaseNumber FROM Case WHERE Id = '" + escapeSoql(caseId) + "'"

            var queryResult = sforce.connection.query(query);
            var record = queryResult.getArray('records');

            var caseNumber = record && record[0] && record[0].CaseNumber || 'Case';

            sforce.console.openSubtab(result.id, '/'+caseId, true, caseNumber);
        });
    });
});
