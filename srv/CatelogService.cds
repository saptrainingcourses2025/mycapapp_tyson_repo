using { tyson.db.master, tyson.db.transaction } from '../db/datamodel';

service CatelogService @(path: 'CatelogService', requires: 'authenticated-user') {

    entity EmployeeSet@(restrict: [
                            {grant:['READ'], to:'Viewer', 
                            // Row Level Security
                            where: 'bankName = $user.spiderman'},
                            {grant:['WRITE','DELETE'], to:'Editor'}
                        ]) 
                        as projection on master.employee;
    entity ProductSet as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    @readonly
    entity StatusCode as projection on master.StatusCode;
    @Capabilities : { Deletable: false }
    entity PurchaseOrderSet @(
                            // restrict: [
                            //     { grant: ['READ'], to: 'Viewer' },
                            //     { grant: ['WRITE', 'DELETE'], to: 'Editor' } 
                            // ],
                            odata.draft.enabled: true,
                            Common.DefaultValuesFunction: 'getDefaultValue' ) as projection on transaction.purchaseorder{
        *,
        // CASE OVERALL_STATUS
        //     when 'P' then 'Pending'
        //     when 'A' then 'Approved' 
        //     when 'X' then 'Rejected'
        //     when 'D' then 'Deliverd'
        //     else 'Unknown'
        //         end as OverallStatus: String(10),

        // CASE OVERALL_STATUS
        //     when 'P' then 2
        //     when 'A' then 3
        //     when 'X' then 1
        //     when 'D' then 3
        //     else 0
        //         end as colorchng: Integer
        case when OVERALL_STATUS = 'A' then cast(3 as Integer)
            when OVERALL_STATUS = 'D' then cast(3 as Integer)
            when OVERALL_STATUS = 'X' then cast(1 as Integer)
            when OVERALL_STATUS = 'P' then cast(2 as Integer)
            else cast(0 as Integer)
        end as colorchng : Integer,

        case when OVERALL_STATUS = 'A' then 'Approved'
            when OVERALL_STATUS = 'D' then 'Delivered'
            when OVERALL_STATUS = 'X' then 'Cancelled'
            when OVERALL_STATUS = 'P' then 'Pending'
            else 'Unknown'
        end as OverallStatus : String(10)
    }
    actions{
        @cds.odata.bindingparameter.name: '_holdingvar'
        @Common.SideEffects : { 
            TargetProperties : [ '_holdingvar/GROSS_AMOUNT','_holdingvar/OVERALL_STATUS' ]
         }
        action boost() returns PurchaseOrderSet
    };
    entity PurchaseItemSet as projection on transaction.poitems;

    function getLargestOrder() returns array of PurchaseOrderSet;

    function getDefaultValue() returns PurchaseOrderSet;
}

