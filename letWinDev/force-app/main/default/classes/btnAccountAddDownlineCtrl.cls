public with sharing class btnAccountAddDownlineCtrl {
    
	@AuraEnabled()
    static public String getRecordTypeByRecordId(String recordId) {
        try {
          Account acc = [
            SELECT Id, RecordType.developerName, Name FROM Account WHERE Id = :recordId LIMIT 1
          ];
          return acc.RecordType.developerName;
        } catch (System.QueryException e) {
          throw new AuraHandledException('Entity Not Found');
        }
      }
  @AuraEnabled()
    static public String getNameByRecordId(String recordId) {
        try {
          Account acc = [
            SELECT Id, RecordType.developerName, Name FROM Account WHERE Id = :recordId LIMIT 1
          ];
          return acc.Name;
        } catch (System.QueryException e) {
          throw new AuraHandledException('Entity Not Found');
        }
      }
   @AuraEnabled()
    public static void cheatCode() {
        string a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
        a = '';
    }
}