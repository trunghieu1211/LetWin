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
                Name: this.findValue(cmp, 'Name'),
                Code: this.findValue(cmp, 'Code'),
                Phone: this.findValue(cmp, 'Phone'),
                Email: this.findValue(cmp, 'Email'),
                PreferredName: this.findValue(cmp, 'PreferredName'),
                EffectiveDate: this.findValue(cmp, 'EffectiveDate'),
                Comment: this.findValue(cmp, 'Comment'),
                Description: this.findValue(cmp, 'Description'),
                Responsible: this.findValue(cmp, 'Responsible'),
                State: this.findValue(cmp, 'State')
            };
            
            var action = cmp.get('c.CreateLineAccount');
            action.setParams({
                jsonModel: JSON.stringify(data),
                recordTypeName: 'Line MKT'
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
                        }
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
        inputCmp.getElement().focus();
        return isValid;
    }
})