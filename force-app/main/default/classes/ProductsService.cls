public with sharing class ProductsService {
    
    public ProductsService() {}
    
    public list<Product2> getProducts() {
        return (new ProductsSelector()).selectProducts();
    }
    
    public List<Product2> searchProducts(List<wrapProduct> tempProductList,List<Product2> tempProducts,Map<Id,wrapProduct> WrapProductMap , String productName) {
        tempProductList.clear();
        tempProducts.clear();
        for(Id key : WrapProductMap.keySet()) {
            if(WrapProductMap.get(key).product.Name.containsIgnoreCase(productName)) {
                tempProductList.add(WrapProductMap.get(key));
                tempProducts.add(WrapProductMap.get(key).product);
            }
        }
        return tempProducts;
    }
    
    public List<wrapProduct> getWrapProducts(List<wrapProduct> tempProductList, ApexPages.StandardSetController setConProduct,Map<Id,wrapProduct> WrapProductMap) {
        tempProductList.clear();
        for(Product2 product : (list<Product2>)setConProduct.getRecords()) {
            tempProductList.add(wrapProductMap.get(product.Id));
        }
        return tempProductList;
    }
    
    
}