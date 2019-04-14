@isTest
public class QueuesDisplayTest{
	
	@TestSetup
	static void setDataForTest1(){
		Group grp1 = new Group();
		grp1.name = 'First Level';
		grp1.Type = 'Queue'; 
		
		Group grp2 = new Group();
		grp2.name = 'Second Level';
		grp2.Type = 'Queue'; 
		
		List<Group> groups = new List<Group>{grp1, grp2};
		insert groups; 
		
		
		QueuesObject qObj = new QueueSObject();
		qObj.QueueId = grp1.Id; 
		qObj.SobjectType = 'Case';
		
		QueuesObject qObj2 = new QueueSObject();
		qObj2.QueueId = grp2.Id; 
		qObj2.SobjectType = 'Case';
		
		List<QueuesObject> queuesObjects = new List<QueuesObject>{qObj, qObj2};
			
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
			insert queuesObjects;
		}
	}
	
	@isTest static void testQueuesDisplayQueuesCount() {
		List<Group> returnGroup;
		Test.startTest();
		returnGroup = QueuesDisplay.getQueues();
		//returnCase = QueuesDisplay.saveResults(testgrp.Id,testCase.Id);
		Test.stopTest();
		System.assert(!returnGroup.isEmpty());
		
		Integer grpCount = 0;
		for(Group grp: returnGroup){
			if(grp.Name == 'First Level' || grp.Name == 'Second Level'){
				grpCount++;
			}
		}
		System.assert(!(grpCount < 2));
	}
	
	@isTest static void testQueuesDisplayUpdateCase() {
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
		caseRec.AccountId = personAccount.Id;
		insert caseRec;
		
		List<Group> returnGroup;
		
		Case caseResult;
		Test.startTest();
		returnGroup = QueuesDisplay.getQueues();
		caseResult = QueuesDisplay.saveResults(returnGroup[0].Id, caseRec.Id);
		Test.stopTest();
		
		System.assertEquals(caseResult.ReassignedDate__c, System.today());
	}
}