({
	init: function(component, event, helper){
		var recordId = component.get("v.recordId"); 
		component.set("v.recordParent", recordId);
        var recordName = "";
		var name = "";
		var action = component.get("c.getRecordTypeByRecordId");
		var action1 = component.get("c.getNameByRecordId");

		var modalCreateAgent = component.find("modalCreateAgent");
		var modalCreateGroup = component.find("modalCreateGroup");
		var modalCreateOverdraft = component.find("modalCreateOverdraft");
		var modalCreateWalkin = component.find("modalCreateWalkin");
		var modalCreateShareHolder = component.find("modalCreateShareHolder");

		action.setParams({ recordId: recordId });
		action1.setParams({recordId: recordId});

	
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				// Xử lý kết quả khi gọi thành công
				recordName = response.getReturnValue();
				switch(recordName){
					case "Line_MKT":{
						modalCreateGroup.openModal();
						return;
					}
					case "Agent":{
						modalCreateAgent.openModal();
						return;
					}
					case "ShareHolder":{
						var firstValue = 'Agent';
						var opts = [{'label': 'Agent', 'value': 'Agent'},
									{'label': 'Secondary ShareHolder', 'value': 'Secondary_ShareHolder'},
								];
						component.set("v.options", opts);
						component.set("v.value", firstValue);
						return;
					}
					case "Group":{
						action1.setCallback(this, function(response) {
							var state = response.getState();
							if (state === "SUCCESS") {
								// Xử lý kết quả khi gọi thành công
								name = response.getReturnValue();
								if (name ==="ZZ"){
									modalCreateOverdraft.openModal();
									return;
								}
								else if (name ==="UU"){
									modalCreateWalkin.openModal();
									return;
								}
								else{
									modalCreateShareHolder.openModal();
									return;
								}
							} 
						});
						$A.enqueueAction(action1);
					}
				}
			} else {
				// Xử lý lỗi nếu có
				console.error("Error calling Apex method: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	handleCancelClick: function (component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},

	handleCreateClick: function (component, event, helper) {
		var modalCreateAgent = component.find("modalCreateAgent");
		var modalCreate2ndShareHolder = component.find("modalCreateSecondarySH");
		var value = component.get("v.value");
                                    
		switch(value) {
			case "Secondary_ShareHolder":{
				modalCreate2ndShareHolder.openModal();
				break;
			}
			case "Agent":{
				modalCreateAgent.openModal();
				break;
			}
		}
	}
})