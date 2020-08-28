public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    public class Equipment {
        public Integer quantity;
        public String name;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Integer cost;
        public String sku;
    }
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //REST endpoint and update equipment on hand.
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            List<Equipment> results = (List<Equipment>)JSON.deserialize(response.getBody(), List<Equipment>.class);
            List<Product2> equipmentList = new List<Product2>();
            for ( Equipment result : results ) {
                equipmentList.add(new Product2(
                    Replacement_Part__c = true,
                    Name = result.name,
                    Cost__c = result.cost,
                    Lifespan_Months__c = result.lifespan,
                    Maintenance_Cycle__c = result.maintenanceperiod,
                    Current_Inventory__c = result.quantity,
                    Warehouse_SKU__c = result.sku,
                    ExternalId = result.sku
                ));           
            }
            if (equipmentList.size() > 0) {
                insert equipmentList;
            }  
        }
    }
}