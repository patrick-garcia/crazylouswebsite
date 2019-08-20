let order = {
  taxRate: 13, // use whole number, converted into decimal inside function
  subtotal: '',
  albumQtys: [...document.getElementsByClassName('qtyOfEachItem')],
  unitPrice: [...document.getElementsByClassName('hiddenUnitPrice')],
  unitPriceArray: [],
  events: ["DOMContentLoaded", "change"]
}

order.startVals = function() {
  this.unitPrice.forEach(elem => this.unitPriceArray.push(elem.value))
}

order.updateEachAlbumTotal = function() {
  this.albumQtys.forEach((val, ind) => {
    let name1 = 'linePrice' + (ind + 1);
    let name2 = 'linePriceHidden' + (ind + 1);
    let name3 = 'qtyHidden' + (ind + 1);
    let qty = val.value;
    let price = this.unitPriceArray[ind];
    document.getElementsByName(name1)[0].innerHTML = (qty * price).toFixed(2);
    document.getElementsByName(name2)[0].value = (qty * price).toFixed(2);
    document.getElementsByName(name3)[0].value = qty;
  })
}

order.getQty = function() {
  let getQty = [...document.getElementsByClassName('hiddenQty')];
  let arrayQty = [];
  getQty.forEach((item) => {
    let val = parseInt(item.value);
    arrayQty.push(val);
  })

  document.getElementById('qtyhidden').value = arrayQty;
}

order.updateSubtotalVal = function() {
  let unitPriceUpdated = [...document.getElementsByClassName('hiddenUnitPrice')];
  let unitPriceArrayUpdated = [];
  unitPriceUpdated.forEach(elem => {
    unitPriceArrayUpdated.push(elem.value)
  })

  this.subtotal = unitPriceArrayUpdated.reduce(function (total, currVal) {
    return (parseFloat(total) + parseFloat(currVal)).toFixed(2);
  })
}

// push vals to html
order.displayTotals = function() {
  let taxElem = document.getElementById('tax');
  let tax = parseFloat(this.subtotal * (this.taxRate / 100)).toFixed(2);
  taxElem.innerHTML = tax;

  let finalTotalElem = document.getElementById('finalTotal');
  let finalTotal = (parseFloat(this.subtotal) + parseFloat(tax)).toFixed(2);
  finalTotalElem.innerHTML = finalTotal;

  let hiddenElem = document.getElementById('finalTotalHidden');
  hiddenElem.value = finalTotal;
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

//run at start
function init() {
  order.startVals()
}

init();

order.events.forEach(evt => {
  window.addEventListener(evt, () => {
    order.runCalc()
  }, false)
})


