import { LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PRE_NAME_FIELD from '@salesforce/schema/Account.Preferred_Name__c';
import CODE_FIELD from '@salesforce/schema/Account.Code__c';
import COMMENT_FIELD from '@salesforce/schema/Account.Comment__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Account.Description';
import EFFECTIVE_DATE_FIELD from '@salesforce/schema/Account.Effective_date__c';
import STATE_FIELD from '@salesforce/schema/Account.State__c';
import REPO_FOR_SALES_FIELD from '@salesforce/schema/Account.Responsible_for_Sales_team__c';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import { getObjectInfo } from "lightning/uiObjectInfoApi";

export default class AccountLineFormCreate extends LightningElement {

accountObject = ACCOUNT_OBJECT;
myFields = [NAME_FIELD, PRE_NAME_FIELD, CODE_FIELD, PHONE_FIELD, COMMENT_FIELD, 
        DESCRIPTION_FIELD, EFFECTIVE_DATE_FIELD, REPO_FOR_SALES_FIELD, STATE_FIELD ];

@track isModalOpen = false;

@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
accountObjectInfor;

handleSuccess(event){
    const toastEvent = new ShowToastEvent({
        title: " Created",
        message: "Record ID: " + event.detail.id,
        variant: "Success"
    });
    this.dispatchEvent(toastEvent);
    this.isModalOpen = false;
}

handleCancel(event){
    this.isModalOpen = false;
}

openModal() {
    this.isModalOpen = true;
}

get recordTypeId() {
    const rtis = this.accountObjectInfor.data.recordTypeInfos;
    return Object.keys(rtis).find((rti) => rtis[rti].name === "Line MKT");
    }
}