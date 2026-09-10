using { tyson.cds } from '../db/CDSViews';

service CDSService @(path: 'CDSService') {
    entity ProductSet as projection on cds.CDSViews.ProductView{
        *,
        virtual soldCount: Int16
    }; 
    entity ItemSet as projection on cds.CDSViews.ItemView;
}
