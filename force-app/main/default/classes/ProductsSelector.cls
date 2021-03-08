public class ProductsSelector extends fflib_SObjectSelector {
    
    Public ProductsSelector() {
        super(false);
    }
    
    public ProductsSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product2.Name,
                Product2.ProductCode,
                Product2.Description,
                Product2.Price_Per_unit__c,
                Product2.quantity_available__c };
                    }
    
    public Schema.SObjectType getSObjectType() {
        return Product2.sObjectType;
    }
    
    public List<Product2> selectProducts() {
        return Database.query('SELECT Name,ProductCode,Description,price_per_unit__c,quantity_available__c FROM Product2  LIMIT 1000');
    }
}