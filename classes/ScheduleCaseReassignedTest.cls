@IsTest
public class ScheduleCaseReassignedTest {
    
    @TestSetup
    static void setUpData(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account personAccount = new Account(
            // RecordTypeID = recordTypeId,
            // FirstName = 'Test FName',
            // LastName = 'Test LName',
            // PersonMailingStreet = 'test@test.com',
            // PersonMailingPostalCode = '12345',
            // PersonMailingCity = 'SFO',
            // PersonEmail = 'test@test.com',
            // PersonHomePhone = '1234567',
            // PersonMobilePhone = '12345678'
        );
        
        Case caseRec = new Case();
        caseRec.ReassignedDate__c = System.today().addDays(-1);
        caseRec.AccountId = personAccount.Id;
        insert caseRec;
    }
    
    @IsTest
    static void testScheduleCaseReassigned(){
        ScheduleCaseReassignedNotifyToCustomer customerToSendNotify = new ScheduleCaseReassignedNotifyToCustomer();
        String sch = '0 0 01 * * ?';
        
        Test.startTest();
        Id jobId = System.schedule('Schedule Apex Send Notification', sch, customerToSendNotify);
        Test.stopTest();
        
        CronTrigger cronTrigger1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(sch, cronTrigger1.CronExpression);
        System.assertEquals(0, cronTrigger1.TimesTriggered);
    }
}