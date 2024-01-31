({
    findValue: function(cmp, find) {
        try {
            var rValue = null;
            try {
                rValue = cmp.find(find).get('v.value');
            }
            catch(e) {
                rValue = cmp.find(find)[0].get('v.value');
            }
            
            return rValue == '' ? null : rValue;
        }
        catch(err) {
            console.log('Could not find ' + find);
            return null;
        }
	},
    
    submitForm: function(cmp, event, isReset) {
        var data = {
                ParentId: this.findValue(cmp, 'Parent'),
                CageId: this.findValue(cmp, 'Cage'),
                Name: this.findValue(cmp, 'Name'),
                Identity: this.findValue(cmp, 'Identity'),
                PreferredName: this.findValue(cmp, 'PreferredName'),
                Code: this.findValue(cmp, 'Code'),
                CKName: this.findValue(cmp, 'CKName'),
                Nickname: this.findValue(cmp, 'Nickname'),
                Gender: this.findValue(cmp, 'Gender'),
                DOB: this.findValue(cmp, 'DOB'),
                Language: this.findValue(cmp, 'Language'),
                Phone: this.findValue(cmp, 'Phone'),
                Email: this.findValue(cmp, 'Email'),
                Passport: this.findValue(cmp, 'Passport'),
                Origin: this.findValue(cmp, 'Origin'),
                HoianaPID: this.findValue(cmp, 'HoianaPID'),
                TheGrandPID: this.findValue(cmp, 'TheGrandPID'),
                Age: this.findValue(cmp, 'Age'),
                Nationality: this.findValue(cmp, 'Nationality'),
                Address: this.findValue(cmp, 'Address'),
                Signup: this.findValue(cmp, 'Signup'),
                SignupLocation: this.findValue(cmp, 'SignupLocation'),
                PreferContactChannel: this.findValue(cmp, 'PreferContactChannel'),
                Referal: this.findValue(cmp, 'Referal'),
                State: this.findValue(cmp, 'State'),
                Comment: this.findValue(cmp, 'Comment'),
                Description: this.findValue(cmp, 'Description'),
                Responsible: this.findValue(cmp, 'Responsible'),
                UploadPassport: this.findValue(cmp, 'UploadPassport'),
                UploadAccForm: this.findValue(cmp, 'UploadAccForm'),
                UploadSignature: this.findValue(cmp, 'UploadSignature')
            }
            
            var action = cmp.get('c.CreateShareHolder');
            action.setParams({
                jsonModel: JSON.stringify(data),
                recordTypeName: 'ShareHolder'
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                cmp.set('v.isDisableClick', false);
                if(response.getState() === 'SUCCESS') {
                    if(result.Id != null) {
                        this.showToastTemplate(
                            'Record was created successfully.', 
                            'A new record was created.', 
                            result.Id,
                            'success', 
                            null
                        );
                        if(isReset == true) {
                            cmp.set("v.isOpenModel", false);
                            cmp.set("v.isOpenModel", true);
                        }
                        else {
                            cmp.set("v.isOpenModel", false);
                            window.location.href = '/' + result.Id;
                        }
                        $A.get("e.force:closeQuickAction").fire();
                    }
                    else {
                        this.showToast(
                            'We got an error.', 
                            result.Description, 
                            'error', 
                            null
                        );
                    }
                }
            });
            $A.enqueueAction(action);
    },
    
	showToast: function (title, message, type, icon) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            title: title,
            message: message,
            duration: '3000',
            key: icon,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
        if(type == 'success') {
            //$A.get('e.force:refreshView').fire();
        }
    },
    
    showToastTemplate: function (title, message, recordId, type, icon) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            title: title,
            message: message,
            messageTemplate: 'A record was created! See it {1}!',
            messageTemplateData: ['Account', {
                url: '/' + recordId,
                label: 'here',
            }],
            duration: '3000',
            key: icon,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
        if(type == 'success') {
            //$A.get('e.force:refreshView').fire();
        }
    },
    
    requiredValidation: function(cmp, name) {
        var isValid = true;
        var inputCmp = cmp.find(name);
        var value = null;
        try {
            value = inputCmp.get('v.value');
        }
        catch(e) {
            value = inputCmp[0].get('v.value');
            inputCmp = inputCmp[0];
        }
        if (value == null || value == '') {
            inputCmp.setCustomValidity('This field is required.');
            isValid = false;
        }
        else {
            inputCmp.setCustomValidity('');
        }
        inputCmp.reportValidity();
        // inputCmp.getElement().focus();
        return isValid;
    }
})