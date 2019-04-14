global class ScheduleCaseReassignedNotifyToCustomer implements Schedulable {
    private final String query = 'SELECT Id, ContactId, AccountId FROM Case WHERE Account.IsPersonAccount = true AND ReassignedDate__c < Today';
    private Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Case_Assignment_First'].Id;
    global void execute(SchedulableContext sc) {
        CaseReassignedNotifyToCustomer batchCaseReassignedNotify = new CaseReassignedNotifyToCustomer(this.query, this.templateId); 
        Database.executeBatch(batchCaseReassignedNotify);
    }
}