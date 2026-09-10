const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CatelogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseItemSet } = cds.entities('CatelogService')

  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)

    let salaryAmount = parseFloat(req.data.salaryAmount);
    if (salaryAmount > 1000000) {
      req.error(500,"Hey Amigo! None of the employee get a million");      
    }
  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)

    for (let index = 0; index < purchaseOrderSet.length; index++) {
      const element = purchaseOrderSet[index];
      if (!element.NOTE) {
        element.NOTE = 'Not Found'
      }      
    }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseItemSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseItemSet', req.data)
  })
  this.after ('READ', PurchaseItemSet, async (purchaseItemSet, req) => {
    console.log('After READ PurchaseItemSet', purchaseItemSet)
  })


  this.on('getLargestOrder', async(req,res)=>{
    try {
      const tx = cds.tx(req);

      const reply = await tx.read(PurchaseOrderSet).orderBy({
        'GROSS_AMOUNT': 'desc'
      }).limit(3);

      return reply;

    } catch (error) {
      req.error(500,"Error: "+ error.toString());
    }
  });

  this.on('boost', async(req) => {        
    // debugger;
    try {
    const PRIMARYKEY = req.params[0];
    const tx = cds.tx(req);

    await tx.update(PurchaseOrderSet).with({
      GROSS_AMOUNT : { '+=' : 20000 },
      NOTE: 'Boosted!'
    }).where(PRIMARYKEY);
    return tx.read(PurchaseOrderSet).where(PRIMARYKEY);     
    } catch (error) {
      // req.error(500,"Error:" + error.toString());
    }
  });

  // Implement the function for default values display
  this.on('getDefaultValue', async(req,res)=>{
    return {
      OVERALL_STATUS: 'N',
      LIFECYCLE_STATUS: 'N'
    }
  });

  return super.init()
}}
