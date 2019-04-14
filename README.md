# CasesReassignment

To Run the schedule job at 1:00 PM daily, kindly run below command in Dev console: 

ScheduleCaseReassignedNotifyToCustomer  schCase = new ScheduleCaseReassignedNotifyToCustomer ();
String sch = '0 0 13 1/1 * ? *';
system.schedule('Notify Customers', sch, schCase);
