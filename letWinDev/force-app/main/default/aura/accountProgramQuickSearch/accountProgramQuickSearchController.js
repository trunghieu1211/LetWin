({
    handleOnchange: function (cmp, event, helper) {
        var searchTerm = cmp.get("v.searchTerm");
        var action = cmp.get("c.getRecordIdByName");
        
        
        if(searchTerm.length < 8){
            return;
        }
        
        action.setParams({
            name: searchTerm
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var recordId = '';
            var toastEvent = $A.get("e.force:showToast");
            
            if (state === "SUCCESS") {
                recordId = response.getReturnValue();
                if(searchTerm.indexOf("P") === 0 || searchTerm.indexOf("p") === 0){
                    var navUrl = $A.get("e.force:navigateToURL");
                    navUrl.setParams({
                        "url": 'https://enterprise-connect-1575--dev.sandbox.lightning.force.com/lightning/r/Program__c/'+ recordId +'/view'
                    });
                    navUrl.fire();
                }
                else{
                    var navUrl = $A.get("e.force:navigateToURL");
                    navUrl.setParams({
                        "url": 'https://enterprise-connect-1575--dev.sandbox.lightning.force.com/lightning/r/Account/'+ recordId +'/view'
                    });
                    navUrl.fire();
                }
                event.target.value='';
                
            }
            
        });
        $A.enqueueAction(action);  
    },
    
    afterRender: function(cmp, event, helper){
        cmp.find("inputtext").focus();
    }
    
    /*handleKeyUp: function (cmp, event, helper){
        
        console.log("keyup");
        var searchTerm = cmp.get("v.searchTerm");
        var action = cmp.get("c.getRecordIdByName");
        var toastEvent = $A.get("e.force:showToast");
        
        action.setParams({
            name: searchTerm
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(searchTerm.length >= 8){
                if (state === "SUCCESS") {
                    var recordId = response.getReturnValue();
                    if(searchTerm.indexOf("P") === 0 || searchTerm.indexOf("P") === 0){
                        var navUrl = $A.get("e.force:navigateToURL");
                        navUrl.setParams({
                            "url": 'https://enterprise-connect-1575--dev.sandbox.lightning.force.com/lightning/r/Program__c/'+ recordId +'/view'
                        });
                        navUrl.fire();
                    }
                    else{
                        var navUrl = $A.get("e.force:navigateToURL");
                        navUrl.setParams({
                            "url": 'https://enterprise-connect-1575--dev.sandbox.lightning.force.com/lightning/r/Account/'+ recordId +'/view'
                        });
                        navUrl.fire();
                    }
                } 
                else {
                    toastEvent.setParams({
                        "message": "Not found Account or Program",
                        "type": "warning"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },*/
})