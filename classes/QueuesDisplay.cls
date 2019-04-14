public class QueuesDisplay{
    @AuraEnabled
    public static List<Group> getQueues() {
        return [SELECT Id, name FROM Group where Type = 'Queue' AND Name IN ('First Level', 'Second level')];  
    }
    
    @AuraEnabled
    public static Case saveResults(String groupId, Id caseId){
        Case cs = new Case();
        cs.Id = caseId;
        cs.OwnerId = groupId;
        cs.ReassignedDate__c = System.today();
        update cs;
        return cs;
    }
}