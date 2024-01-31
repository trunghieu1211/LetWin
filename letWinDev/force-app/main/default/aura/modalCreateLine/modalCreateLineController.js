({
    init: function (cmp, event, helper) {
        document.addEventListener('keydown', (event) => {if (event.key === 'Escape') {cmp.set("v.isOpenModel", false);}});
        var action = cmp.get('c.initPicklist');
        action.setParams({});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                var lstLanguage = [];
                var lstNationality = [];
                var lstState = [];
                for(var i = 0; i < result.length; i++) {
                    if(result[i].EntityParticle.DeveloperName == 'Language') {
                        lstLanguage.push(result[i].Value);
                    }
                    if(result[i].EntityParticle.DeveloperName == 'Nationality') {
                        lstNationality.push(result[i].Value);
                    }
                    if(result[i].EntityParticle.DeveloperName == 'State') {
                        lstState.push(result[i].Value);
                    }
                }
                cmp.set('v.lstLanguage', lstLanguage);
                cmp.set('v.lstNationality', lstNationality);
                cmp.set('v.lstState', lstState);
            }
        });
        $A.enqueueAction(action);
    },
    
	OpenModel: function (cmp, event, helper) {
        cmp.set("v.isOpenModel", true);
    },
    
    CloseModel: function (cmp, event, helper) {
        cmp.set("v.isOpenModel", false);
    },
    
    Submit: function (cmp, event, helper) {
        if(cmp.get('v.isDisableClick') == true) {
            return;
        }
        else {
            cmp.set('v.isDisableClick', true);
        }
        var allValid = helper.requiredValidation(cmp, 'Name');
        
        if (allValid) {
            helper.submitForm(cmp, event, false);
        }
    },
    
    SaveReset: function (cmp, event, helper) {
        if(cmp.get('v.isDisableClick') == true) {
            return;
        }
        else {
            cmp.set('v.isDisableClick', true);
        }
        var allValid = helper.requiredValidation(cmp, 'Name');
        
        if (allValid) {
            helper.submitForm(cmp, event, true);
        }
    },
})