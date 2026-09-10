sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"tyson/ui/managepo/test/integration/pages/PurchaseOrderSetList.gen",
	"tyson/ui/managepo/test/integration/pages/PurchaseOrderSetObjectPage.gen",
	"tyson/ui/managepo/test/integration/pages/PurchaseItemSetObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSetListGenerated, PurchaseOrderSetObjectPageGenerated, PurchaseItemSetObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('tyson/ui/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetListGenerated: PurchaseOrderSetListGenerated,
			onThePurchaseOrderSetObjectPageGenerated: PurchaseOrderSetObjectPageGenerated,
			onThePurchaseItemSetObjectPageGenerated: PurchaseItemSetObjectPageGenerated
        },
        async: true
    });

    return runner;
});

