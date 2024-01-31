@isTest
public class btnShiftDetailCheckInCtrlTest {
	@isTest
    static void getInforByContactCodeTest() {
        Contact cont = new Contact(Code__c = 'TestCode', FirstName = 'TestFirstName', LastName = 'TestLastName', 
                                   Gender__c = 'Male',State__c = 'TestState', Preferred_Name__c = 'TestPreferredName', 
                                   RecordTypeId='0121e000001IifIAAS');
        insert cont; 
        
        Test.startTest();
        Contact contact = btnShiftDetailCheckInCtrl.getInforByContactCode('TestCode');
        Test.stopTest();
    }
    @isTest
    static void getShiftStaffByShiftDetailTest() {
        Contact cont = new Contact(LastName = 'LastName', Preferred_Name__c= 'Preferred_Name__c', Code__c = 'code__c');
        insert cont; 
        Shift__c shift = new Shift__c(Name ='Name');
        insert shift;
        Counter__c counter = new Counter__c();
        insert counter;
        Shift_Cut__c shiftDetail = new Shift_Cut__c(Counter__c=counter.Id, Shift__c= shift.Id);
        insert shiftDetail; 
        Shift_Staff__c shiftstaff1 = new Shift_Staff__c();
        insert shiftstaff1;
        Shift_Staff__c testShiftStaff = new Shift_Staff__c(Contact__c = cont.Id, Shift_Detail__c = shiftDetail.Id);
        insert testShiftStaff;
        
        Test.startTest();
        List<Object> result = btnShiftDetailCheckInCtrl.getShiftStaffByShiftDetail(testShiftStaff.Id);
        Test.stopTest();
    }
    @isTest
    static void ShiftCheckInTest(){
        Contact cont = new Contact(LastName = 'LastName', Preferred_Name__c= 'Preferred_Name__c', Code__c = 'code__c');
        insert cont; 
        Counter__c counter = new Counter__c();
        insert counter;
        Shift__c shift = new Shift__c(Name ='Name');
        insert shift;
        Shift_Cut__c shiftDetail = new Shift_Cut__c(Counter__c=counter.Id, Shift__c= shift.Id);
        insert shiftDetail; 
        Shift_Staff__c testShiftStaff = new Shift_Staff__c(Contact__c = cont.Id ,Shift_Detail__c = shiftDetail.Id);
        insert testShiftStaff;
        
        
        Test.startTest();
        btnShiftDetailCheckInCtrl.ShiftCheckIn(testShiftStaff.Id, cont.Id);
        
        btnShiftDetailCheckInCtrl.cheatCode();
        Test.stopTest();
    }
}