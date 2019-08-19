let taxRate = 13; // use whole number, to be converted into decimal inside function
let subtotal;
let albumQtys = [...document.getElementsByClassName('qtyOfEachItem')];
let unitPrice = [...document.getElementsByClassName('hiddenUnitPrice')];
let unitPriceArray = [];
unitPrice.forEach(function (elem, ind) {
  unitPriceArray.push(elem.value)
})

function runCalc() {
  albumQtys.forEach(function (val, ind) {
    let name1 = 'linePrice' + (ind + 1);
    let name2 = 'linePriceHidden' + (ind + 1);
    let name3 = 'qtyHidden' + (ind + 1);
    let qty = val.value;
    let price = unitPriceArray[ind];
    document.getElementsByName(name1)[0].innerHTML = (qty * price).toFixed(2);
    document.getElementsByName(name2)[0].value = (qty * price).toFixed(2);
    document.getElementsByName(name3)[0].value = qty;
  })

  getQty();

  let unitPriceUpdated = [...document.getElementsByClassName('hiddenUnitPrice')];
  let unitPriceArrayUpdated = [];
  unitPriceUpdated.forEach(function (elem, ind) {
    unitPriceArrayUpdated.push(elem.value)
  })

  subtotal = unitPriceArrayUpdated.reduce(function (total, currVal) {
    return (parseFloat(total) + parseFloat(currVal)).toFixed(2);
  })

  let subtotalElem = document.getElementById('subtotal');
  subtotalElem.innerHTML = subtotal;

  let taxElem = document.getElementById('tax');
  let tax = parseFloat(subtotal * (taxRate / 100)).toFixed(2);
  taxElem.innerHTML = tax;

  let finalTotalElem = document.getElementById('finalTotal');
  let finalTotal = (parseFloat(subtotal) + parseFloat(tax)).toFixed(2);
  finalTotalElem.innerHTML = finalTotal;

  let hiddenElem = document.getElementById('finalTotalHidden');
  hiddenElem.value = finalTotal;

  getTotals();
}

// ****
function getQty() {
  let getQty = [...document.getElementsByClassName('hiddenQty')];
  let arrayQty = [];
  getQty.forEach((item) => {
    let val = parseInt(item.value);
    arrayQty.push(val);
  })
  document.getElementById('qtyhidden').value = arrayQty;
}

function getTotals() {
  let getTotals = [...document.getElementsByClassName('totalItems')];
  let arrayTotals = [];
  getTotals.forEach((item) => {
    let val = parseFloat(item.innerHTML);
    arrayTotals.push(val);
  })
  
  document.getElementById('totals').value = arrayTotals;
}

["DOMContentLoaded", "change"].forEach(function(evt) {
  window.addEventListener(evt, runCalc, false)
})



