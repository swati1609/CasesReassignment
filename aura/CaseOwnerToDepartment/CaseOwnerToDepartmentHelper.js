({
    displayOptions : function(component, event, helper) {
        var queues = component.get("c.getQueues");
        console.log('queues', queues);
        queues.setCallback(this, function(response) {
            var state = response.getState(); 
            if (component.isValid() && state === "SUCCESS") { 
                component.set("v.AllQueues", response.getReturnValue());
                console.log("AllQueues" + response.getReturnValue());
                $A.get('e.force:refreshView').fire();
                
                var returnVal = response.getReturnValue();
                var finalList = [];
                for(var i=0; i<returnVal.length; i++)
                {
                    var queue = returnVal[i];
                    queue.label = queue.Name;
                    queue.value = queue.Id;
                    finalList.push(queue);         
                }
                
                component.set("v.AllQueuesOptions", finalList);
            }
            else if (state === "ERROR") {
                var errorMessage = response.getError();
                console.error(errorMessage);  
            }
            
            
        });
        $A.enqueueAction(queues);
        
    },
    saveResult : function(component, event, helper) {
        var selectedGroup = component.get("v.selectedQueueId");
        var caseId = component.get("v.recordId");
        var saveResultMethod = component.get("c.saveResults");
        saveResultMethod.setParams({"groupId":selectedGroup, "caseId":caseId });
        saveResultMethod.setCallback(this, function(response) {
            var state = response.getState(); 
            if (component.isValid() && state === "SUCCESS") { 
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errorMessage = response.getError();
                console.error(errorMessage);  
            }
        });
        $A.enqueueAction(saveResultMethod);
    }
})