sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"tyson/aa/poanalytics/test/integration/pages/PurchaseAnalyticsList.gen",
	"tyson/aa/poanalytics/test/integration/pages/PurchaseAnalyticsObjectPage.gen"
], function (JourneyRunner, PurchaseAnalyticsListGenerated, PurchaseAnalyticsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('tyson/aa/poanalytics') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseAnalyticsListGenerated: PurchaseAnalyticsListGenerated,
			onThePurchaseAnalyticsObjectPageGenerated: PurchaseAnalyticsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

