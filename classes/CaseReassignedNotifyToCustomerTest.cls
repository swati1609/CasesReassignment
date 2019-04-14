@IsTest
public class CaseReassignedNotifyToCustomerTest {
	private static final String query = 'SELECT Id, ContactId, AccountId FROM Case WHERE Account.IsPersonAccount = true AND ReassignedDate__c < Today';
	private static final Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Case_Assignment_First'].Id;
	
	@TestSetup
	static void setUpData(){
		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		Account personAccount = new Account(
			RecordTypeID = recordTypeId,
			FirstName = 'Test FName',
			LastName = 'Test LName',
			PersonMailingStreet = 'test@test.com',
			PersonMailingPostalCode = '12345',
			PersonMailingCity = 'SFO',
			PersonEmail = 'test@test.com',
			PersonHomePhone = '1234567',
			PersonMobilePhone = '12345678'
		);
		insert personAccount;
		
		Case caseRec = new Case();
		caseRec.ReassignedDate__c = System.today().addDays(-1);
		caseRec.AccountId = personAccount.Id;
		caseRec.ContactId = [SELECT PersonContactId FROM Account WHERE Id =: personAccount.Id].PersonContactId;
		insert caseRec;
	}
	
	@IsTest
	static void testBatchNotificationToCustomers(){
		CaseReassignedNotifyToCustomer batchNotificationToCustomers = new CaseReassignedNotifyToCustomer(query, templateId); 
		
		Integer invocations;
		Test.startTest();
		Database.executeBatch(batchNotificationToCustomers);
		Test.stopTest();
		
		Case caseRec = [SELECT 
						Id,
						ReassignedDate__c
						FROM Case
						LIMIT 1];
		
		System.assertEquals(null, caseRec.ReassignedDate__c);
	}
}