public with sharing class ContentLibraryController {
List<ContentWorkspaceDoc> ws;
    public static ID firstLibraryID; //store firstLibraryID (ContentWorkspaceID)
    
    //public swWorkspaceCon() {
    //    ws = getRecords();
    //}
 
    //@AuraEnabled
    //public List<ContentWorkspaceDoc> getWs() {
    //    if(ws == null) ws = getRecords();
    //    return ws;
    //}
    @AuraEnabled
    public Static List<ContentWorkspaceDoc> getRecords() {
        List<ContentWorkspaceDoc> wsList = new List<ContentWorkspaceDoc>();
        wsList = [SELECT ContentWorkspaceID, ContentWorkspace.Name, ContentDocumentID, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.Owner.FirstName, ContentDocument.Owner.LastName, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.VersionNumber FROM ContentWorkspaceDoc WHERE ContentDocumentId IN (SELECT ContentDocumentId FROM ContentVersion) ORDER BY ContentWorkspace.Name, ContentDocument.Title];
        return wsList;
    }
    @AuraEnabled
    public Static List<ContentWorkspaceDoc> getLibraryNames() {//get WorkspaceNames (Library Names)
        String wsDocId;
        List<ContentWorkspaceDoc> wsDocNames = new List<ContentWorkspaceDoc>();
        List<ContentWorkspaceDoc> wsList = new List<ContentWorkspaceDoc>();
        wsList = [SELECT ContentWorkspaceID, ContentWorkspace.Name, ContentDocumentID, ContentDocument.Title, ContentDocument.FileType, ContentDocument.Owner.FirstName, ContentDocument.Owner.LastName, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.VersionNumber FROM ContentWorkspaceDoc WHERE ContentDocumentId IN (SELECT ContentDocumentId FROM ContentVersion) ORDER BY ContentWorkspace.Name, ContentDocument.Title];
        if(wsList.size()>0){
            firstLibraryID = wsList[0].ContentWorkspaceID;
        }
        for(ContentWorkspaceDoc wsDoc: wsList){ // get Unique Library Names
            if(wsDocId != wsDoc.ContentWorkspaceID){
                wsDocNames.add(wsDoc);
            }
            wsDocId = wsDoc.ContentWorkspaceID;    
        }
        return wsDocNames;
    }    
    @AuraEnabled
    public Static List<ContentWorkspaceDoc> getFirstLibraryRecordsByWorkSpaceId()
     {
        ID wsId = firstLibraryID;
        List<ContentWorkspaceDoc> wsList = new List<ContentWorkspaceDoc>();
        wsList = [SELECT ContentWorkspaceID, ContentWorkspace.Name, ContentDocumentID, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.Owner.FirstName, ContentDocument.Owner.LastName, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.VersionNumber FROM ContentWorkspaceDoc WHERE ContentWorkspaceID =: wsId ORDER BY ContentWorkspace.Name, ContentDocument.Title];
        return wsList;
    }
    @AuraEnabled
    public Static List<ContentWorkspaceDoc> getLibraryRecordsByWorkSpaceId(Id wsId)
     {
        List<ContentWorkspaceDoc> wsList = new List<ContentWorkspaceDoc>();
        wsList = [SELECT ContentWorkspaceID, ContentWorkspace.Name, ContentDocumentID, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.Owner.FirstName, ContentDocument.Owner.LastName, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.VersionNumber FROM ContentWorkspaceDoc WHERE ContentWorkspaceID =: wsId ORDER BY ContentWorkspace.Name, ContentDocument.Title];
        return wsList;
    }
    //@AuraEnabled //NOT USED
    //public Static List<ContentVersion> getContentRecords() {
    //    return [SELECT ContentUrl, Id, Document_Type__c, FileType, PathOnClient, ContentSize, SystemModstamp, VersionNumber, ContentDocumentId, Title FROM ContentVersion];
    //}
   
     /* Determines whether the surrent user is a guest or not */
    @AuraEnabled
    public static boolean isGuestUser() {
        String userType = getUserType();
        System.debug('Switching off of user type: ' + userType);
        return (userType == 'Guest' ? true : false);
    }
    
    /* Determines the current user type */
    @AuraEnabled
    public static String getUserType() {
        Id userId = UserInfo.getUserId();
        System.debug('User type for user: ' + UserInfo.getUserType());
        return UserInfo.getUserType();
    }
    
    @AuraEnabled
    public static boolean isHighVolumeUser() {
        Id roleId = UserInfo.getUserRoleId();
        System.debug('Retrieved role ID ' + roleId);
        return (roleId != null || roleId == '' ? false : true);
    }
    
    @AuraEnabled
    public static String getUserRole() {
        Id roleId = UserInfo.getUserRoleId();
        System.debug('Retrieved role ID ' + roleId);
        return roleId;
    }
}