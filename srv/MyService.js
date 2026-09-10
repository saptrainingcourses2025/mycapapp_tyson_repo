const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {

  this.on ('tyson', async (req) => {
    console.log('On tyson', req.data)
    let myName = req.data.name;
    return `Welcome to CAP Service! Hello ${myName}, How are you doing today?`;
  })

  return super.init()
}}
