const cds = require('@sap/cds')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    // console.log('After READ ProductSet', productSet)

    let ids = productSet.map(p=>p.ProductId);

    const orderCount = await SELECT.from(ItemSet)
                                   .columns('ProductId', {func: 'count', as: 'totalCount'})
                                   .where({'ProductId': {in:ids}})
                                   .groupBy('ProductId')

    for (let index = 0; index < productSet.length; index++) {
      const element = productSet[index];
      const foundRecord = orderCount.find(pc=>pc.ProductId === element.ProductId);
      element.soldCount = foundRecord ? foundRecord.totalCount : 0;    
      // element.soldCount=2; 
    }

  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })


  return super.init()
}}
