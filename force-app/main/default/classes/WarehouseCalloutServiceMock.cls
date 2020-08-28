@isTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    public HttpResponse respond(HttpRequest request) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('[{"_id": "55d66226726b611100aaf741","replacement": false,"quantity": 5,"name": "Generator 1000 kW"}]');
        return res;
        
    }
}