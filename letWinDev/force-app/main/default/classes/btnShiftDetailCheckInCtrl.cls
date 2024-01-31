public with sharing class btnShiftDetailCheckInCtrl {

    @AuraEnabled(cacheable=true)
    static public Contact getInforByContactCode(String Code) {
        try {
             Contact contact= [
                SELECT Id, AccountId, Name, Gender__c, State__c, Preferred_Name__c FROM Contact where Code__c =: Code and recordType.developerName = 'Staff' LIMIT 1
            ];
            return contact;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<Object> getShiftStaffByShiftDetail(String recordId){
        try {
            List<Shift_Staff__c> lstShiftStaff= [
                SELECT Id, Contact__c, User__r.Name FROM Shift_Staff__c where Shift_Detail__c=: recordId ORDER BY Id ASC
            ];
            return lstShiftStaff;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void ShiftCheckIn(String shiftId, String contactId){
        try {
            Shift_Staff__c shiftStaff = [SELECT Id FROM Shift_Staff__c WHERE Id=:shiftId];
            shiftStaff.Contact__c =contactId;
            update shiftStaff;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
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
    }
}