const cds = require('@sap/cds')

module.exports = async function () {

  //Implementing Function Imports
  const db = await cds.connect.to('db') // connect to database service
  const { Books } = db.entities         // get reflected definitions

  // Reduce stock of ordered books if available stock suffices
  this.on('submitOrder', async req => {
    const { book, quantity } = req.data
    const n = await UPDATE(Books, book)
      .with({ stock: { '-=': quantity } })
      .where({ stock: { '>=': quantity } })
    n > 0 || req.error(409, `${quantity} exceeds stock for book #${book}`)
  }),

    // Register your event handlers in here, for example, ...
    this.after('READ', 'Books', each => {
      if (each.stock > 111) {
        each.title += ` -- 11% discount!`
      }
    }),

    //IMPLEMENTING FUNCTIONS  
    this.on('hello', req => `Hello ${req.data.to}!`)

}