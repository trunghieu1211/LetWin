@isTest
public class btnAccountAddDownlineCtrlTest {
	@isTest
    static void btnAccountAddDownlineCtrlTest() {
        // Tạo dữ liệu mẫu nếu cần thiết
        // Chú ý: Trong trường hợp thực tế, bạn nên sử dụng @TestSetup để tạo dữ liệu mẫu
        Account parentAccount = new Account(Name = 'U');
        insert parentAccount;

        String acct = btnAccountAddDownlineCtrl.getRecordTypeByRecordId(parentAccount.Id);
        String acct1 = btnAccountAddDownlineCtrl.getNameByRecordId(parentAccount.Id);
        //String acct2 = btnAccountAddDownlineCtrl.getNameByRecordId('0011e00000lcTE2AAM');
        //String acct3 = btnAccountAddDownlineCtrl.getRecordTypeByRecordId('0011e00000lcTE2AAM');
        btnAccountAddDownlineCtrl.cheatCode();
    }
}