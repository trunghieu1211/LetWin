public with sharing class QuickSearchBarController {
  @AuraEnabled(cacheable=true)
  static public String getAccountIdByCode(String code) {
    try {
      Account acc = [
        SELECT Id, Name
        FROM Account
        WHERE Code__c = :code
        LIMIT 1
      ];
      return acc.Id;
    } catch (System.QueryException e) {
      throw new AuraHandledException('Entity Not Found');
    }
  }

  @AuraEnabled(cacheable=true)
  static public String getAccountRemarkIdByName(String name) {
    try {
      Account_Remark__c accr = [
        SELECT Id, Name
        FROM Account_Remark__c
        WHERE Name = :name
        LIMIT 1
      ];
      return accr.Id;
    } catch (System.QueryException e) {
      throw new AuraHandledException('Entity Not Found');
    }
  }

  @AuraEnabled(cacheable=true)
  static public String getProgramIdByName(String name) {
    try {
      Program__c pro = [
        SELECT Id, Name
        FROM Program__c
        WHERE Name = :name
        LIMIT 1
      ];
      return pro.Id;
    } catch (System.QueryException e) {
      throw new AuraHandledException('Entity Not Found');
    }
  }
}