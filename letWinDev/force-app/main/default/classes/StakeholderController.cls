public without sharing class StakeholderController {
    @AuraEnabled
    public static DataHelper.ModelPaging getAccountPaging(string conditions, string order, integer page, integer take) {
        try {
            integer offset = ((page == 1) ? 0 : (page - 1) * take);
            string query = 'SELECT Id, Name, Code__c, RecordType.Name, Preferred_Name__c, Parent.Name, Type, Owner.Name, CreatedDate ';
            query += 'FROM Account WHERE ' + conditions + ' ';
            if(order != null && order != '') {
                query += 'ORDER BY ' + order + ' ';
            }
            else {
                query += 'ORDER BY LastModifiedDate DESC ';
            }
            query += 'LIMIT ' + string.valueOf(take) + ' OFFSET ' + string.valueOf(offset);
            
            string queryCount = 'SELECT COUNT(Id) cnt FROM Account WHERE ' + conditions;
            AggregateResult count = Database.query(queryCount);
            List<Account> lstData = Database.query(query);
            
            DataHelper.ModelPaging result = new DataHelper.ModelPaging();
            result.TotalRecords = (integer)count.get('cnt');
            result.PageSize = take;
            result.TotalPages = integer.valueOf(Math.ceil((double)result.TotalRecords/(double)result.PageSize));
            result.PageNumber = page;
            result.Data = lstData;
            
            return result;
        }
        catch(Exception e) {
            DataHelper.Log('Exception', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static List<Account> getListAccount() {
        List<Account> lstAcc = [
            SELECT Id, Name, RecordType.Name, Preferred_Name__c, Parent.Name, Type, Owner.Name, CreatedDate
            FROM Account
            ORDER BY LastModifiedDate DESC
        ];
        return lstAcc;
    }
    
    @AuraEnabled
    public static List<PicklistValueInfo> initPicklist() {
        return [
            SELECT Label, Value, EntityParticle.DeveloperName
            FROM PicklistValueInfo 
            WHERE EntityParticle.EntityDefinition.QualifiedApiName = 'Account'
            AND  EntityParticle.DeveloperName IN ('Language', 'Nationality', 'State')
            AND isActive = true 
            ORDER BY label 
        ];
    }
    
    @AuraEnabled
    public static Account CreateLineAccount(string jsonModel, string recordTypeName) {
        Account acc = new Account();
        try {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonModel);
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            acc.RecordTypeId = recordTypeId;
            acc.Name = (string)m.get('Name');
            acc.Preferred_Name__c = (string)m.get('PreferredName');
            acc.Code__c = (string)m.get('Code');
            acc.Phone = (string)m.get('Phone');
            acc.Email__c = (string)m.get('Email');
            acc.State__c = (string)m.get('State');
            acc.Comment__c = (string)m.get('Comment');
            acc.Description = (string)m.get('Description');
            acc.Responsible_for_Sales_team__c = (string)m.get('Responsible');
            acc.Effective_date__c = tryParseDate(m.get('EffectiveDate'));
            insert acc;
            DataHelper.Log('acc', m);
        }
        catch(Exception e) {
            acc.Description = e.getMessage();
            DataHelper.Log('Exception', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return acc;
    }
    
    @AuraEnabled
    public static Account CreateGroupAccount(string jsonModel) {
        Account acc = new Account();
        try {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonModel);
            acc.ParentId = (string)m.get('ParentId');
            acc.Name = (string)m.get('Name');
            acc.RecordTypeId = RecordtypeHelper.ACOUNT_GROUP;
           	acc.Preferred_Name__c = (string)m.get('PreferredName');
            acc.Code__c = (string)m.get('Code');
            acc.Email__c = (string)m.get('Email');
            acc.Responsible_for_Sales_team__c = (string)m.get('Responsible');
            acc.Effective_date__c = tryParseDate(m.get('Effective'));
            acc.Comment__c = (string)m.get('Comment');
            acc.Description = (string)m.get('Description');
            acc.Phone = (string)m.get('Phone');
            acc.State__c = (string)m.get('State');
            acc.isWalkin__c = DataHelper.tryParseBoolean(m.get('isWalkin'));
            insert acc;
        }
        catch(Exception e) {
            acc.Description = e.getMessage();
            DataHelper.Log('Exception', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return acc;
    }
    
    @AuraEnabled
    public static Account CreateOverDraft(string jsonModel) {
        Account acc = new Account();
        try {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonModel);
            acc.ParentId = (string)m.get('ParentId');
            acc.Name = (string)m.get('Name');
            acc.RecordTypeId = RecordtypeHelper.OVERDRAFT;
            acc.Preferred_Name__c = (string)m.get('PreferredName');
            //acc.Code__c = (string)m.get('Code');
            acc.Email__c = (string)m.get('Email');
            acc.Overdraft_limit__c = DataHelper.tryParseInteger(m.get('Overdraft'));
            acc.Phone = (string)m.get('Phone');
            acc.Comment__c = (string)m.get('Comment');
            acc.Description = (string)m.get('Description');
            acc.State__c = (string)m.get('State');
            acc.isNegative__c = DataHelper.tryParseBoolean(m.get('isNegative'));
            insert acc;
            
            List<Wallet__c> lstWallet = new List<Wallet__c>();
            List<Cage__c> lstCages = [SELECT Id FROM Cage__c];
            List<Currency__c> lstCurrencies = [SELECT Id FROM Currency__c WHERE Active__c = true AND Main_Currency__c = true];
            for(Cage__c cg : lstCages) {
                for(Currency__c curr : lstCurrencies) {
                    Wallet__c w = new Wallet__c();
                    w.Account__c = acc.Id;
                    w.Cage__c = cg.Id;
                    w.Currency__c = curr.Id;
                    w.Deposit__c = 0;
                    w.Chip_Transfer__c = 0;
                    w.Commission__c = 0;
                    w.Frozen__c = 0;
                    w.Loan__c = 0;
                    w.Maker__c = 0;
                    w.Rolling_Amount__c = 0;
                    w.Shareholder_Dividends__c = 0;
                    w.Win_Loss__c = 0;
                    w.Balance_Amount__c = 0;
                    lstWallet.add(w);
                }
            }
            if(lstWallet != null && lstWallet.size() > 0) {
                insert lstWallet;
            }
        }
        catch(Exception e) {
            acc.Description = e.getMessage();
            DataHelper.Log('Exception', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return acc;
    }
    
    @AuraEnabled
    public static Account CreateShareHolder(string jsonModel, string recordTypeName) {
        Account acc = new Account();
        try {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonModel);
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            acc.ParentId = (string)m.get('ParentId');
            acc.Cage__c = (string)m.get('CageId');
            acc.RecordTypeId = recordTypeId;
            acc.Identity__c = (string)m.get('Identity');
            acc.Preferred_Name__c = (string)m.get('PreferredName');
            acc.Code__c = (string)m.get('Code');
            acc.Chinese_Korean_Name__c = (string)m.get('CKName');
            acc.Nickname__c = (string)m.get('Nickname');
            acc.Gender__c = (string)m.get('Gender');
            acc.Date_of_birth__c = tryParseDate(m.get('DOB'));
            acc.Language__c = (string)m.get('Language');
            acc.Phone = (string)m.get('Phone');
            acc.Email__c = (string)m.get('Email');
            acc.Passport_No__c = (string)m.get('Passport');
            acc.Origin__c = (string)m.get('Origin');
            acc.Hoiana_PID__c = (string)m.get('HoianaPID');
            acc.The_Grand_PID__c = (string)m.get('TheGrandPID');
            acc.Age__c = (string)m.get('Age');
            acc.Nationality__c = (string)m.get('Nationality');
            acc.Address__c = (string)m.get('Address');
            acc.Signup_Date__c = tryParseDate(m.get('Signup'));
            acc.Signup_location__c = (string)m.get('SignupLocation');
            acc.Prefer_contact_channel__c = (string)m.get('PreferContactChannel');
            acc.Referal__c = (string)m.get('Referal');
            acc.State__c = (string)m.get('State');
            acc.Comment__c = (string)m.get('Comment');
            acc.Description = (string)m.get('Description');
            acc.Responsible_for_Sales_team__c = (string)m.get('Responsible');
            acc.Upload_Passport__c = (string)m.get('UploadPassport');
            acc.Upload_Open_Account_Form__c = (string)m.get('UploadAccForm');
            acc.Upload_signature_style__c = (string)m.get('UploadSignature');
            acc.Name = (string)m.get('Name');
            acc.Upline_Account__c = (string)m.get('Upline');
            insert acc;
            
            //Customer
            Id customerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Contact cus = new Contact();
            cus.AccountId = acc.Id;
            cus.Cage__c = acc.Cage__c;
            cus.RecordTypeId = customerRecordTypeId;
            cus.Identity__c = (string)m.get('Identity');
            cus.Preferred_Name__c = (string)m.get('PreferredName');
            cus.Code__c = (string)m.get('Code');
            cus.Chinese_Korean_Name__c = (string)m.get('CKName');
            cus.Nickname__c = (string)m.get('Nickname');
            cus.Gender__c = (string)m.get('Gender');
            cus.Date_of_birth__c = tryParseDate(m.get('DOB'));
            cus.Language__c = (string)m.get('Language');
            cus.MobilePhone = (string)m.get('Phone');
            cus.Email__c = (string)m.get('Email');
            cus.Passport_No__c = (string)m.get('Passport');
            cus.Origin__c = (string)m.get('Origin');
            cus.Hoiana_PID__c = (string)m.get('HoianaPID');
            cus.The_Grand_PID__c = (string)m.get('TheGrandPID');
            cus.Age__c = (string)m.get('Age');
            cus.Nationality__c = (string)m.get('Nationality');
            cus.Address__c = (string)m.get('Address');
            cus.Signup_Date__c = tryParseDate(m.get('Signup'));
            cus.Signup_location__c = (string)m.get('SignupLocation');
            cus.Prefer_contact_channel__c = (string)m.get('PreferContactChannel');
            cus.Referal__c = (string)m.get('Referal');
            cus.State__c = (string)m.get('State');
            cus.Comment__c = (string)m.get('Comment');
            cus.Description__c = (string)m.get('Description');
            cus.Responsible_for_Sales_team__c = (string)m.get('Responsible');
            cus.Upload_Passport__c = (string)m.get('UploadPassport');
            cus.Upload_Open_Account_Form__c = (string)m.get('UploadAccForm');
            cus.Upload_signature_style__c = (string)m.get('UploadSignature');
            cus.LastName = acc.Preferred_Name__c;
            //cus.FirstName = acc.Preferred_Name__c;
            cus.Upline_Account__c = (string)m.get('Upline');
            insert cus;
            
            Id playerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Player').getRecordTypeId();
            Contact player = new Contact();
            player.AccountId = acc.Id;
            player.Cage__c = acc.Cage__c;
            player.RecordTypeId = playerRecordTypeId;
            player.Identity__c = (string)m.get('Identity');
            player.Preferred_Name__c = (string)m.get('PreferredName');
            player.Code__c = (string)m.get('Code');
            player.Chinese_Korean_Name__c = (string)m.get('CKName');
            player.Nickname__c = (string)m.get('Nickname');
            player.Gender__c = (string)m.get('Gender');
            player.Date_of_birth__c = tryParseDate(m.get('DOB'));
            player.Language__c = (string)m.get('Language');
            player.MobilePhone = (string)m.get('Phone');
            player.Email__c = (string)m.get('Email');
            player.Passport_No__c = (string)m.get('Passport');
            player.Origin__c = (string)m.get('Origin');
            player.Hoiana_PID__c = (string)m.get('HoianaPID');
            player.The_Grand_PID__c = (string)m.get('TheGrandPID');
            player.Age__c = (string)m.get('Age');
            player.Nationality__c = (string)m.get('Nationality');
            player.Address__c = (string)m.get('Address');
            player.Signup_Date__c = tryParseDate(m.get('Signup'));
            player.Signup_location__c = (string)m.get('SignupLocation');
            player.Prefer_contact_channel__c = (string)m.get('PreferContactChannel');
            player.Referal__c = (string)m.get('Referal');
            player.State__c = (string)m.get('State');
            player.Comment__c = (string)m.get('Comment');
            player.Description__c = (string)m.get('Description');
            player.Responsible_for_Sales_team__c = (string)m.get('Responsible');
            player.Upload_Passport__c = (string)m.get('UploadPassport');
            player.Upload_Open_Account_Form__c = (string)m.get('UploadAccForm');
            player.Upload_signature_style__c = (string)m.get('UploadSignature');
            //player.LastName = acc.Name + ' ' + acc.Chinese_Korean_Name__c;
            player.LastName = acc.Preferred_Name__c;
            player.Upline_Account__c = (string)m.get('Upline');
            insert player;
            
            List<Wallet__c> lstWallet = new List<Wallet__c>();
            List<Cage__c> lstCages = [SELECT Id FROM Cage__c];
            List<Currency__c> lstCurrencies = [SELECT Id FROM Currency__c WHERE Active__c = true AND Main_Currency__c = true];
            for(Cage__c cg : lstCages) {
                for(Currency__c curr : lstCurrencies) {
                    Wallet__c w = new Wallet__c();
                    w.Account__c = acc.Id;
                    w.Cage__c = cg.Id;
                    w.Currency__c = curr.Id;
                    w.Deposit__c = 0;
                    w.Chip_Transfer__c = 0;
                    w.Commission__c = 0;
                    w.Frozen__c = 0;
                    w.Loan__c = 0;
                    w.Maker__c = 0;
                    w.Rolling_Amount__c = 0;
                    w.Shareholder_Dividends__c = 0;
                    w.Win_Loss__c = 0;
                    w.Balance_Amount__c = 0;
                    lstWallet.add(w);
                }
            }
            if(lstWallet != null && lstWallet.size() > 0) {
                insert lstWallet;
            }
        }
        catch(Exception e) {
            System.debug(e.getMessage());
            acc.Description = e.getMessage();
            DataHelper.Log('Exception', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return acc;
    }
    
    public static date tryParseDate(object v) {
        try {
            string[] strDate = string.valueOf(v).split('-');
            Date result = date.newInstance(integer.valueOf(strDate[0]), integer.valueOf(strDate[1]), integer.valueOf(strDate[2]));
            return result;
        }
        catch(Exception e) {
            
        }
        return null;
    }
    @AuraEnabled
    public static String getNameByRecordId(String RecordId) {
        try {
            // Thực hiện truy vấn để lấy Name dựa vào trường recordId
            Account acc = [SELECT Id, Name FROM Account WHERE Id =: recordId LIMIT 1];
            return acc.Name;
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}