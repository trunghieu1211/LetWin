import { LightningElement , track, api} from 'lwc';
import { CloseActionScreenEvent} from "lightning/actions";
import Toast from 'lightning/toast';
import { NavigationMixin } from 'lightning/navigation';
import getInforByContactCode from '@salesforce/apex/btnShiftDetailCheckInCtrl.getInforByContactCode';
import getShiftStaffByShiftDetail from '@salesforce/apex/btnShiftDetailCheckInCtrl.getShiftStaffByShiftDetail';
import ShiftCheckIn from '@salesforce/apex/btnShiftDetailCheckInCtrl.ShiftCheckIn';

export default class ShiftDetailShiftCheckIn extends NavigationMixin(LightningElement) {
    @api recordId;
    Name;PreferredName;State;Gender;
    selectedUserId;contactId;
    filter = {criteria: [],};
    Counter_Options=[];
    shiftStaff=[];

    goToRecordPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Shift_Staff__c',
                actionName: 'view',
            },
        });
    }

    showToastSuccess(){
        Toast.show({
            label: 'Success',
            message: `${this.Name} Check-In Success`,
            variant: 'Success'
        })
    }

    handleCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleChangePickerCage(event){
        const pickerCage = event.detail.recordId;
        // const today = new Date();
        // const year = today.getFullYear();
        // const month = String(today.getMonth() + 1).padStart(2, '0');
        // const day = String(today.getDate()).padStart(2, '0');

        // let date = `${year}-${month}-${day}`;

        this.filter = {
            criteria: [
                {
                    fieldPath: 'Cage__c',
                    operator: 'eq',
                    value: pickerCage,
                },
                {
                    fieldPath: 'CreatedDate',
                    operator: 'eq',
                    value: { literal: 'TODAY' }
                },
                // {
                //     fieldPath: 'Cage_Date__c',
                //     operator: 'eq',
                //     value: date,
                // },
          ],}
    }
    
    async handleChangePickerShift(event){
        const id = this.recordId;
        this.shiftStaff = await getShiftStaffByShiftDetail({recordId: id});
        
        // let counter = 1;
        
        // this.shiftStaff.forEach((item) => {
        //     var cont = item.Contact__c;
        //     var id = item.Id;
        //     var user = item.User__r.Name;

        //     var radioOption = '';
        //     if(this.isAccount(cont)){
        //         radioOption = `
        //             <input type="radio" class="radio" name="radioBtn" data-id="${id}" id="radio${counter}" value="${id}" style="margin-left:32px; margin-top:8px; margin-bottom:8px; height:20px; width:20px; vertical-align: middle;">
        //             <label style="font-size:1em; margin-top:3px;" for="radio${counter}">${user}</label><br>`;
        //         counter++;
        //     }
        //     else{
        //         radioOption = ` 
        //             <input type="radio" disabled="" style="margin-left:32px; margin-top:8px; margin-bottom:8px; height:20px; width:20px; vertical-align: middle;">
        //             <label style="font-size:1em; margin-top:3px;" >${user}</label><br>`;
        //     }

        //     this.template.querySelector('.slds-p-top_x-small').insertAdjacentHTML('beforeend', radioOption);
        //     var radioInput = this.template.querySelector(`#radio${counter - 1}`);
        //     if(radioInput) {
        //         radioInput.addEventListener('change', this.handleChange);
        //     }
        // })
    }

    async hanldeGetInfor(event){
        const Code = event.target.value;
        const infor = await getInforByContactCode({Code: Code});
        this.Name = infor.Name;
        this.PreferredName = infor.Preferred_Name__c;
        this.Gender = infor.Gender__c;
        this.State = infor.State__c;
        this.contactId = infor.Id;
    }
    
    handleChange(event){
        // var selectedAccountId = event.currentTarget.dataset.id;
        this.selectedUserId = event.target.value;
    }

    handleClick(event){
        ShiftCheckIn({shiftId: this.selectedUserId, contactId: this.contactId});
        this.handleCancel();
        this.goToRecordPage(this.selectedUserId);
        this.showToastSuccess();
    }
}