// githinji.mwangi@resilient-otter-8o2u7u.com 
public class MaintenanceRequestHelper {
public static Boolean runOnce = true;
Date today = Date.today();
Integer maintenanceCycle;
Set<Id>caseIds = new Set<Id>();
List<Case> caseRequestList = new List<Case>();    

public void MaintenanceRequestHelper(List<Case>maintenanceCases) {
    // When an existing maintenance request of type Repair or Routine Maintenance is Closed,
    // create a new maintenance request for a future routine checkup.
    
    for ( Case newCase : maintenanceCases){
        caseIds.add(newCase.Id);
    }
    List<Case>closedCaseQuery = [SELECT Id, Vehicle__c, Equipment__c,
                                    (SELECT Id, Equipment__r.Maintenance_Cycle__c 
                                    FROM Work_Parts__r 
                                    ORDER BY Equipment__r.Maintenance_Cycle__c ASC)
                                    FROM Case WHERE Id IN :caseIds
                                    AND IsClosed = true 
                                    AND (Type = 'Repair' OR Type = 'Routine Maintenance')];
    if (!closedCaseQuery.isEmpty()) { //check if list is empty before executing           	
        for ( Case closedCase : closedCaseQuery) {
            maintenanceCycle = Integer.valueOf(closedCase.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c);
            if (maintenanceCycle != null) { // Check to ensure there is a workpart to avoid List Index out of bounds error
                maintenanceCycle = maintenanceCycle;
                }else {
                    maintenanceCycle = 10;
                }
                caseRequestList.add(new Case(
                    Type = 'Routine Maintenance',
                    Subject = 'New Routine Maintenance',
                    Origin = 'Email',
                    Status = 'New',
                    vehicle__c = closedCase.Vehicle__c,
                    Equipment__c = closedCase.Equipment__c,
                    Date_Reported__c = today,
                    Date_Due__c = today.addDays(maintenanceCycle)          
                ));
            }            
            if(caseRequestList.size() > 0) {
                insert caseRequestList;   
            }
        }
        
    }
}

/* Key take Aways
Always study the schema diagram carefully, It will help with sObject relationships.
Study the scenario and make pseudocodes.
Incase of a SOQL query, try as much to make request filters using it(greatly reduce your conditions on code).
Think of all edge cases if possible.
*/