using CatelogService as service from '../../srv/CatelogService';

annotate service.PurchaseOrderSet with@(

    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS
    ],

    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatelogService.boost',
            Label: 'Boost',
            Inline : true,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
            Criticality: colorchng
        }        
    ], 

    UI.HeaderInfo:{
        TypeName: 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title: {Value: PO_ID},
        Description: {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSQI3FoYeFjvh5W2t2exZfh8RQOT5Tt6demQQHk4FuhA&s=10'
    },

    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label: 'Header Details',
            Facets : [
                {
                    Label: 'General Information',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification',
                },
                {
                    Label: 'Pricing Details',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#FG1',
                },
                {
                    Label: 'Additional Data',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#FG2',
                },
            ],            
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label: 'Item Details',
            Target : 'Items/@UI.LineItem',
        },
    ],

    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NOTE,
        },
    ],

    UI.FieldGroup #FG1:{        
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ],
    },

    UI.FieldGroup #FG2:{
        Data: [
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS,
            },
        ]
        
    }

);

annotate service.PurchaseItemSet with @(
    UI.HeaderInfo: {
        TypeName : 'PO Item',
        TypeNamePlural : 'Purchase Order Items',
        Title: {Value : PO_ITEM_POS},
        Description : {Value: PRODUCT_GUID.DESCRIPTION},
    },

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label: 'Item Overview',
            Target : '@UI.Identification',
        }, 
    ],

    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ],
    
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
    ]
);

annotate service.PurchaseOrderSet with{
    @Common.Text: NOTE
    PO_ID;
    @Common.Text: PARTNER_GUID.COMPANY_NAME    
    @ValueList.entity: service.BusinessPartnerSet
    // @Common: {TextArrangement : #TextOnly}
    // @UI.Hidden: true
    PARTNER_GUID;
};

annotate service.PurchaseItemSet with{
    @Common.Text: PRODUCT_GUID.DESCRIPTION
    @ValueList.entity: service.ProductSet
    // @Common: {TextArrangement : #TextOnl
    PRODUCT_GUID;
};

//Value help for Partner_Guid and Product_Guid
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
);

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
);

annotate service.PurchaseOrderSet with {
    OVERALL_STATUS @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'StatusCode',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : OVERALL_STATUS,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.StatusCode with {
    code @Common.Text : value
};

