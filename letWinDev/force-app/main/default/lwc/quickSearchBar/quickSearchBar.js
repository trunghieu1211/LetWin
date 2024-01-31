import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Toast from 'lightning/toast';
import getAccountIdByCode from "@salesforce/apex/QuickSearchBarController.getAccountIdByCode";
import getAccountRemarkIdByName from "@salesforce/apex/QuickSearchBarController.getAccountRemarkIdByName";
import getProgramIdByName from "@salesforce/apex/QuickSearchBarController.getProgramIdByName";

export default class QuickSearchBar extends NavigationMixin(LightningElement) {
    static delegatesFocus = true;

    async handleKeyUp(event) {
        if (!(event.keyCode === 13 || event.keyCode === 9)) {
            return false;
        }
        const searchKey = event.target.value;
        if (this.isAccount(searchKey)) {
            try {
                const result = await getAccountIdByCode({ code: searchKey });
                event.target.value = '';
                this.goToRecordPage(result);
            } catch (e) {
                this.notFound('Account');
            }
        }
        if (this.isProgram(searchKey)) {
            try {
                const result = await getProgramIdByName({ name: searchKey });
                event.target.value = '';
                this.goToRecordPage(result);
            } catch (e) {
                this.notFound('Program');
            }
        }
        if (this.isAccountRemark(searchKey)) {
            try {
                const result = await getAccountRemarkIdByName({ name: searchKey });
                event.target.value = '';
                this.goToRecordPage(result);
            } catch (e) {
                this.notFound('Account Remark');
            }
        }
        return true;
    }

    goToRecordPage(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view',
            },
        });
    }

    isAccount(string) {
        const pat = /^([a-z]{2,}(?!-))(.*)$/gmi;
        return pat.test(string);
    }

    isProgram(string) {
        const pat = /^(P-)(.*)$/gmi
        return pat.test(string)
    }

    isAccountRemark(string) {
        const pat = /^(RM-)(.*)$/gmi;
        return pat.test(string);
    }

    notFound(string = 'Entity') {
        Toast.show({
            label: 'Not Found',
            message: `${string} Not Found.`,
            variant: 'warning'
        })
    }
}