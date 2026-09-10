namespace tyson.cds;
using { tyson.db.master, tyson.db.transaction } from './datamodel';

context CDSViews {
    define view ![POWorkList] as 
        select from transaction.purchaseorder{
            Key PO_ID as![PurchaseOrderId],
            Items.PO_ITEM_POS as![ItemPosition],
            PARTNER_GUID.BP_ID as![PartnerId],
            PARTNER_GUID.COMPANY_NAME as![CompanyName],
            GROSS_AMOUNT as![GrossAmount],
            NET_AMOUNT as![NetAmount],
            TAX_AMOUNT as![TaxAmount],
            CURRENCY as![CurrencyCode],
            OVERALL_STATUS as![OverAllStatus],
            Items.PRODUCT_GUID.PRODUCT_ID as![ProductId],
            Items.PRODUCT_GUID.DESCRIPTION as![Description],
            PARTNER_GUID.ADDRESS_GUID.CITY as ![City],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country]        
        };

    define view ![ProductViewHelp] as 
        select from master.product{
            @EndUserText.label:[
                {
                    language: 'EN',
                    text: 'Product Id'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Id'
                },
            ]
            PRODUCT_ID as![ProductId],
            @EndUserText.label:[
                {
                    language: 'EN',
                    text: 'Product Description'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Descrikption'
                },
            ]            
            DESCRIPTION as![Description]
        };

        define view ![ItemView] as
            select from transaction.poitems{
                key PARENT_KEY.PARTNER_GUID.NODE_KEY as![CustomerId],
                key PRODUCT_GUID.NODE_KEY as![ProductId],
                CURRENCY as![CurrencyCode],
                GROSS_AMOUNT as![GrossAmount],
                NET_AMOUNT as![NetAmount],
                TAX_AMOUNT as![TaxAmount],
                PARENT_KEY.OVERALL_STATUS as![Status]
            };

        define view ![ProductView] as   
            select from master.product
            mixin{
                PO_ORDER: Association to many ItemView on
                    PO_ORDER.ProductId = $projection.ProductId
            }into {
                NODE_KEY as![ProductId],
                DESCRIPTION as![Description],
                CATEGORY as![Category],
                PRICE as![Price],
                SUPPLIER_GUID.BP_ID as![SupplierId],
                SUPPLIER_GUID.COMPANY_NAME as![CompanyName],
                SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],
                PO_ORDER as![To_Items]
            };
        
        define view ![CProductValuesView] as
            select from ProductView{
                ProductId,
                Country,
                round(sum(To_Items.GrossAmount),2) as![TotalAmount],
                To_Items.CurrencyCode as![CurrencyCode]
            }group by ProductId, 
                Country, To_Items.CurrencyCode 
}
