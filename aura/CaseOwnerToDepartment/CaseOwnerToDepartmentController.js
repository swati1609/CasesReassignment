({
    toggle : function(component) {
        component.set("v.showDetailView", false);
        component.set("v.showEditView", true);
    },
    toggle2 : function(component) {
        component.set("v.showDetailView", true);
        component.set("v.showEditView", false);
        component.set("v.selectedQueueId", "");
        component.set("v.disableSaveButton", true);
    },
    ReassignAction : function(component, event, helper) {
        helper.displayOptions(component, event, helper);
	},
    SaveradioResult : function(component, event, helper) {
        helper.saveResult(component, event, helper);
        var showDetail = component.get('c.toggle2');
        $A.enqueueAction(showDetail);
    },
    onRadio : function(component) {
        component.set("v.disableSaveButton", false);
    }
})