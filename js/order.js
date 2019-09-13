let order = {
  taxRate: 13, // use whole number, converted into decimal inside function
  subtotal: '',
  albumQtys: [...document.getElementsByClassName('qtyOfEachItem')],
  unitPriceEach: [...document.querySelectorAll('[data-unitprice]')],
  unitPriceArray: [],
  events: ["DOMContentLoaded", "change"]
}

order.startVals = function() {
  this.unitPriceEach.forEach(elem => {
    this.unitPriceArray.push(elem.dataset.unitprice)
  })
}

order.updateEachAlbumTotal = function() {
  this.albumQtys.forEach((val, ind) => {
    let name1 = 'linePrice' + (ind + 1);
    let name2 = `[data-albumrow="${ind + 1}"]`
    let qty = val.value;
    let price = this.unitPriceArray[ind];
    document.getElementsByName(name1)[0].innerHTML = (qty * price).toFixed(2);
    document.querySelector(name2).setAttribute('data-qty', qty)
  })
}

order.getQty = function() {
  let qtyOfEach = [...document.querySelectorAll('[data-albumrow]')]
  let arrayQty = [];

  qtyOfEach.forEach((item) => {
    let val = parseInt(item.dataset.qty);
    arrayQty.push(val);
  })

  document.getElementById('qtyhidden').value = arrayQty;
}

order.updateSubtotalVal = function() {
  let unitPriceUpdated = [...document.getElementsByClassName('updatedLinePrices')];
  let unitPriceArrayUpdated = [];

  unitPriceUpdated.forEach(elem => {
    let stringToNum = parseFloat(elem.innerText).toFixed(2)
    unitPriceArrayUpdated.push(stringToNum)
  })

  this.subtotal = unitPriceArrayUpdated.reduce((total, currVal) => {
    return (parseFloat(total) + parseFloat(currVal)).toFixed(2);
  })
}

// push vals to html
order.displayTotals = function() {
  let subtotalElem = document.getElementById('subtotal');
  subtotalElem.innerHTML = this.subtotal;

  let taxElem = document.getElementById('tax');
  let tax = parseFloat(this.subtotal * (this.taxRate / 100)).toFixed(2);
  taxElem.innerHTML = tax;

  let finalTotalElem = document.getElementById('finalTotal');
  let finalTotal = (parseFloat(this.subtotal) + parseFloat(tax)).toFixed(2);
  finalTotalElem.innerHTML = finalTotal;
}

order.getTotals = function () {
  let getTotals = [...document.getElementsByClassName('totalItems')];
  let arrayTotals = [];
  getTotals.forEach((item) => {
    let val = parseFloat(item.innerHTML);
    arrayTotals.push(val);
  })

  document.getElementById('totals').value = arrayTotals; // for php
}

order.runCalc = function() {
  this.updateEachAlbumTotal()
  this.getQty();
  this.updateSubtotalVal();
  this.displayTotals();
  this.getTotals();
}

//  *** load 
window.onload = order.startVals()

order.events.forEach(evt => {
  window.addEventListener(evt, () => {
    order.runCalc()
  }, false)
})


