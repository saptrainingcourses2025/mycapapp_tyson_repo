using { tyson.cds } from '../db/CDSViews';

service AnalyticsSrv @(path: 'POAnalytics') {
    entity PurchaseAnalytics as projection on cds.CDSViews.POWorkList{
        *
    }; 
}
