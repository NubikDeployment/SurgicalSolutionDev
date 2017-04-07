@isTest
public class ContentLibraryControllerTest {
    List<ContentWorkspaceDoc> ws;
    public static ID firstLibraryID = '068B0000000zwOyIAI'; //store firstLibraryID (ContentWorkspaceID)
    
    static testMethod void test() {
    ContentLibraryController wsCon = new ContentLibraryController();
    Test.startTest();
      ContentLibraryController.getRecords();
      ContentLibraryController.getLibraryNames(); 
      ContentLibraryController.getFirstLibraryRecordsByWorkSpaceId();
      ContentLibraryController.getLibraryRecordsByWorkSpaceId(firstLibraryID);
      ContentLibraryController.isGuestUser();
      ContentLibraryController.getUserType();
      ContentLibraryController.isHighVolumeUser();
      ContentLibraryController.getUserRole();
    Test.stopTest();
    }
}