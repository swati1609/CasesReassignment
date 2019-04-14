global class CaseReassignedNotifyToCustomer implements Database.Batchable<sObject> {
	public String query;
	public Id templateId;
	global CaseReassignedNotifyToCustomer(String query, Id templateId){
		this.query = query;
		this.templateId = templateId;
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator(this.query);
	}
	
	global void execute(Database.BatchableContext bc, List<Case> scope){
		List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
		Set<Id> caseIds = new Set<Id>();
		for(Case caseRecord: scope){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTargetObjectId(caseRecord.ContactId);
			mail.setWhatId(caseRecord.Id);
			mail.setTemplateId(templateId);
			sendEmailList.add(mail);
			caseIds.add(caseRecord.Id);
		}
		Messaging.sendEmail(sendEmailList);
		this.updateCase(caseIds);
	}
	
	private void updateCase(Set<Id> caseIds){
		List<Case> toUpdateCase = new List<Case>();
		for(Id caseId: caseIds){
			Case caseRecord = new Case();
			caseRecord.Id = caseId;
			caseRecord.ReassignedDate__c = null;
			toUpdateCase.add(caseRecord);
		}
		
		if(!toUpdateCase.isEmpty()){
			try{
				update toUpdateCase;
			} catch (Exception ex){
				//Todo: Save it in logs object if needed
			}
		}
	}
	
	global void finish(Database.BatchableContext BC){}
	
}