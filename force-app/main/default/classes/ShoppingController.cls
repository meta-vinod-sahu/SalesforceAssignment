public class ShoppingController {
    
    Private String getProductsQuery;
    public String ProductName{get;set;}
    private Integer StartingPageRecord{get;set;}
    private Integer EndingPageRecord{get;set;}
    public boolean RenderOrders{get;set;}
    public boolean RenderProducts{get;set;}
    public boolean RenderCart{get;set;}
    public boolean RenderInvoice{get;set;}
    public boolean isSorted{get;set;}
    public List<Product2> tempProducts ;
    public ProductsService proService;
    public CartService cartServiceObj;
    public OrdersService orderServiceObj;
    /*
* constructor
*/
    public ShoppingController() {
        RenderOrders = true;
        RenderProducts = false;
        RenderCart = false;
        RenderInvoice = false ;
        MakeItReadOnly = false;
        isSorted = false;
        sortOrderBy = 'Id';
        SelectedWrapProducts = new List<wrapProduct>();
        tempProductList = new List<wrapProduct>();
        tempProducts = new List<Product2>();
        wrapProductMap = new Map<Id,wrapProduct>();
        proService = new ProductsService();
        cartServiceObj = new CartService();
        orderServiceObj = new OrdersService();
        for(Product2 product : getproducts()) {
            wrapProductMap.put(product.Id,new wrapProduct(product));
        }
    }
    
    /* ----------------------------- Product Section ------------------------------------ */
    
    public ApexPages.StandardSetController setConProduct {
        get {
            if(setConProduct==null) {
                setConProduct = new ApexPages.StandardSetController(tempProducts);
                setConProduct.setPageSize(10) ;
            }
            return setConProduct;
        }
        set;
    }
    
    public list<Product2> getProducts() {
        tempProducts = proService.getProducts();
        setConProduct.setSelected(tempProducts);
        system.debug('hi');
        return tempProducts;
    }
    
    public Integer getStartingPageRecord() {
        startingPageRecord = setConProduct.getPageNumber() * setConProduct.getPageSize() - (setConProduct.getPageSize() - 1);
        return startingPageRecord;
    }
    
    public Integer getEndingPageRecord() {
        EndingPageRecord = setConProduct.getPageNumber() * setConProduct.getPageSize() ;
        return Math.min(EndingPageRecord,setConProduct.getResultSize());
    }
    
    public void SortData() {
        tempProductList.sort();
        isSorted = true ;
    }
    
    public void SearchProduct() {
        tempProducts = proService.SearchProducts(tempProductList,tempProducts,WrapProductMap , productName);
        setConProduct = null;
        setConProduct.setSelected(tempProducts);
        
    }
    
    /* -----------------------------------Product Wrapper and cart----------------------------------------------------- */
    
    public Map<Id,wrapProduct> WrapProductMap {get; set;}
    public List<wrapProduct> tempProductList {get ; set ;}
    public List<wrapProduct> SelectedWrapProducts {get; set;}
    public Id WrappedProductId {get;set;}
    public Integer previousQuantity {get;set;}
    public boolean MakeItReadOnly {get;set;}
    
    public List<wrapProduct> getWrapProducts() {
        if(isSorted == true) {
            isSorted = false;
            return tempProductList;
        }
        tempProductList = proService.getWrapProducts(tempProductList,setConProduct,WrapProductMap);
        return tempProductList;
    }
    
    public void addSelected() {
        previousQuantity = 0;
        SelectedWrapProducts = cartServiceObj.addItemsToCart(WrapProductMap, SelectedWrapProducts);
        if(SelectedWrapProducts.size() > 0){
            RenderCart = true;
        }
    }
    
    public list<wrapProduct> getCartItems() {
        return SelectedWrapProducts;
    }
    
    public void updateQuantity() {
        SelectedWrapProducts = cartServiceObj.updateItemQuantity(WrapProductMap,SelectedWrapProducts,WrappedProductId,previousQuantity);
    }
    
    public void setPreviousQuantity() {
        
    }
    
    public void removeFromCart() {
        SelectedWrapProducts = cartServiceObj.removeItemFromCart(SelectedWrapProducts ,WrappedProductId);
        if(SelectedWrapProducts.size() == 0) {
            RenderCart = false;
        }
    }
    
    public void checkout() {
        RenderCart = false;
        RenderProducts = false;
        RenderOrders = false;
        RenderInvoice = true;
        MakeItReadOnly = true;
    }
    
    /* ----------------------------------------------order section ------------------------------------------------------- */
    
    private String sortOrderBy ;
    public Decimal totalPrice = 0; 
    private Integer StartingPageRecordOrder {get;set;}
    private Integer EndingPageRecordOrder {get;set;}
    
    public ApexPages.StandardSetController setConOrder {
        get{
            if(setConOrder==null) {
                setConOrder = new ApexPages.StandardSetController(Database.query('SELECT ID,Price__c,status__c FROM PlacedOrder__c ORDER BY '+sortOrderBy+' DESC LIMIT 1000'));
            }
            return setConOrder;
        }
        set;
    }
    
    public Integer getStartingPageRecordOrder() {
        startingPageRecordOrder = setConOrder.getPageNumber() * setConOrder.getPageSize() - (setConOrder.getPageSize() - 1);
        return startingPageRecordOrder;
    }
    
    public Integer getEndingPageRecordOrder() {
        EndingPageRecordOrder = setConOrder.getPageNumber() * setConOrder.getPageSize() ;
        return Math.min(EndingPageRecordOrder,setConOrder.getResultSize());
    }
    
    public list<PlacedOrder__c> getOrders() {
        return (list<PlacedOrder__c>)setConOrder.getRecords();
    }
    
    public void sortOrder() {
        setConOrder = null;
        sortOrderBy = 'price__c';
    }
    
    public void addPurchase() {
        RenderProducts = true;
    }
    
    public Decimal getTotalOrderPrice() {
        totalPrice = orderServiceObj.calculateTotalPrice(SelectedWrapProducts);
        return totalPrice;
    }
    
    public pageReference placeOrder() {
        PlacedOrder__c newOrder = orderServiceObj.insertOrder(totalPrice,SelectedWrapProducts);
        return new PageReference('/'+newOrder.Id);
    }  
}