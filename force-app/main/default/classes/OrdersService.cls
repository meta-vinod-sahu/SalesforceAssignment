public class OrdersService {
    
    public OrdersService() {}
    
    public Decimal calculateTotalPrice(List<wrapProduct> SelectedWrapProducts) {
        Decimal totalPrice = 0; 
        for(Integer index = 0 ; index < SelectedWrapProducts.size() ; index++ ){
            totalPrice += SelectedWrapProducts[index].product.price_per_unit__c * SelectedWrapProducts[index].quantity;
        }
        return totalPrice;
    }
    
    public PlacedOrder__c insertOrder(Decimal totalPrice,List<wrapProduct> SelectedWrapProducts) {
        
        PlacedOrder__c newOrder = new PlacedOrder__c(Price__c = totalPrice , status__c = 'pending');
        insert newOrder ; 
        List<cart__c> productOrderLineItems = new List<cart__c>();
        List<Product2> productsToUpdate = new List<Product2>();
        for(wrapProduct wrap : SelectedWrapProducts) {
            productOrderLineItems.add( new cart__c(	PlacedOrder__c = newOrder.Id , product__c = wrap.product.Id , quantity__c = wrap.quantity , 
                                                   total__c = wrap.quantity * wrap.product.price_per_unit__c , cartStatus__c = 'cleared'));
            productsToUpdate.add(wrap.product);
        }
        insert productOrderLineItems;
        update productsToUpdate;
        return newOrder;
    }
    
}
