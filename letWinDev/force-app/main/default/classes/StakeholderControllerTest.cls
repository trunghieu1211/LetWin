@isTest
private class StakeholderControllerTest {

    @isTest
    static void StakeholderControllerTest() {
        StakeholderController.initPicklist();
        // Tạo dữ liệu mẫu nếu cần thiết
        
        Account parentAccount = new Account(Name = 'Parent Account');
        insert parentAccount;
        
        Currency__c curr = new Currency__c(Name = 'Currency', Active__c = true, Main_Currency__c = true);
        insert curr;
        
        Cage__c cage = new Cage__c(Name ='All',Currency__c = curr.Id);
        insert cage;

        String jsonString = '{"ParentId": "'+parentAccount.Id+'","Cage":"'+cage.Id+'", "Identity" :"Identity",   "PreferredName" :"PreferredName",   "Code" : "Code",   "CKName" :"CKName",   "Nickname" :"nkName",   "Gender" : "Male",   "DOB" : "12/01/2001",   "Language" : "Language",   "Phone" : "Phone",   "Email" : "Ema@gmail.com",   "Passport" : "Passport",   "Origin" : "Origin",   "HoianaPID" :"HoianaPID",   "TheGrandPID" : "TheGrandPID",   "Age" : "Age",   "Nationality" : "Nationality",   "Address" : "Address",   "Signup" :"25/12/2023",   "SignupLocation" : "SignupLocation",   "PreferContactChannel" :"PreferContactChannel",   "Referal" : "Referal",   "State" : true,   "Comment" : "Comment",   "Description" : "Description",   "Responsible" : "Responsible",   "UploadPassport" : "UploadPassport",   "UploadAccForm" :"UploadAccForm",   "UploadSignature" : "UploadSignature",   "Name" : "Name","Upline" : "Upline"}';
        Account createdAccount = StakeholderController.CreateShareHolder(jsonString,'Agent');
        
    }
}