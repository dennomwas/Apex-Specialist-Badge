@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest static void testGetCallout() {
        // Set mock callout Class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        // Call method to test
        WarehouseCalloutService.runWarehouseEquipmentSync();  
    }
}