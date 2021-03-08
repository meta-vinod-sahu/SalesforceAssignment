public class CartService {
    
    public CartService() {}
    
    public List<wrapProduct> addItemsToCart(Map<Id,wrapProduct> WrapProductMap,List<wrapProduct> SelectedWrapProducts) {
        for(Id key : WrapProductMap.keySet()) {
            if(WrapProductMap.get(key).selected == true && WrapProductMap.get(key).product.quantity_available__c > 0 ) {
                if(!SelectedWrapProducts.contains(WrapProductMap.get(key))) {
                    SelectedWrapProducts.add(WrapProductMap.get(key));
                }else{
                    WrapProductMap.get(key).quantity++;
                }
                WrapProductMap.get(key).product.quantity_available__c -- ;
            }
        }
        return SelectedWrapProducts;
    }
    
    public List<wrapProduct> updateItemQuantity(Map<Id,wrapProduct> WrapProductMap,List<wrapProduct> SelectedWrapProducts, Id WrappedProductId,Integer previousQuantity) {
        for(Integer index = 0 ; index < SelectedWrapProducts.size() ; index++ ) {
            if(SelectedWrapProducts[index].product.Id == WrappedProductId){
                if(SelectedWrapProducts[index].quantity <= 0 || (SelectedWrapProducts[index].quantity - previousQuantity) > SelectedWrapProducts[index].product.quantity_available__c){
                    SelectedWrapProducts[index].quantity = previousQuantity;
                    previousQuantity = 0;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Tried to enter invalid quantity..'));
                    return SelectedWrapProducts;
                }
                SelectedWrapProducts[index].product.quantity_available__c += previousQuantity - SelectedWrapProducts[index].quantity ;
                previousQuantity = 0;
            }
        }
        return SelectedWrapProducts;
    }
    
    public List<wrapProduct> removeItemFromCart(List<wrapProduct> SelectedWrapProducts ,Id WrappedProductId) {
        for(Integer index = 0 ; index < SelectedWrapProducts.size() ; index++ ){
            if(SelectedWrapProducts[index].product.Id == WrappedProductId){
                SelectedWrapProducts[index].product.quantity_available__c += SelectedWrapProducts[index].quantity;
                SelectedWrapProducts[index].quantity = 1;
                SelectedWrapProducts[index].selected = false;
                SelectedWrapProducts.remove(index); 
            }
        }
        return SelectedWrapProducts;
    }
}