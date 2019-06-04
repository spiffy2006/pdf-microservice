const express = require('express')
const pdf = require('chrome-headless-render-pdf')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  const RenderPDF = require('chrome-headless-render-pdf');
  console.log(req.query)
  // return res.send(req.query)
  RenderPDF.generatePdfBuffer(req.query.url, {chromeOptions: ['--ignore-certificate-errors', '-no-sandbox']})
    .then((pdfBuffer) => {
      console.log('sending back data')
      // res.set('Content-Type', 'application/pdf');
      res.send(pdfBuffer)
    }).catch((err) => {
      console.error(err)
      res.send(err)
    });
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))