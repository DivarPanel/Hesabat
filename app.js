const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbxvsRYOgM90BDHtgoX1G0ze1WPRX-AuZ1qTulOSlhzd5HMc9ezARcGzLaTro6w9AeSxoA/exec";
let currentUser = null; 
let cart = [];
let productsList = [];
let transactionsList = [];
let tempProduct = null; // Modal üçün müvəqqəti məhsul

document.addEventListener("DOMContentLoaded", () => {
  loadDataFromSheets();
});

async function loadDataFromSheets() {
  showToast("DivarPanel bazasından yüklənir...", "blue");
  try {
    const response = await fetch(APPS_SCRIPT_URL, { method: "GET", redirect: "follow" });
    const textData = await response.text();
    let data;
    try { data = JSON.parse(textData); } catch(err) { throw new Error("Giriş xətası"); }

    if(data && data.status === "success") {
      productsList = data.products || [];
      transactionsList = data.transactions || [];
      renderProducts();
      renderStockTable();
      renderReportsTable();
      renderDashboardStats();
      showToast("Baza ilə uğurla sinxronlaşdırıldı!", "emerald");
    }
  } catch(err) {
    showToast("Bazadan məlumat oxunmadı.", "rose");
  }
}

function login() {
  const pin = document.getElementById('pinInput').value.trim();
  if (pin === '3285') { currentUser = { name: 'Bəhram' }; } 
  else if (pin === '2255') { currentUser = { name: 'Sadiq' }; } 
  else { document.getElementById('loginError').classList.remove('hidden'); return; }
  
  document.getElementById('loginScreen').classList.add('hidden');
  document.getElementById('activeUser').innerText = currentUser.name;
  document.getElementById('mobileActiveUser').innerText = currentUser.name;
  nav('dashboard');
  loadDataFromSheets();
}

function logout() {
  currentUser = null;
  document.getElementById('pinInput').value = '';
  document.getElementById('loginScreen').classList.remove('hidden');
}

function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  document.getElementById('view-' + target).classList.remove('hidden');
  document.querySelectorAll('.nav-btn').forEach(btn => {
    btn.classList.toggle('text-blue-600', btn.dataset.target === target);
  });
}

function renderProducts(filter = "") {
  const grid = document.getElementById('posProductGrid');
  if(!grid) return;
  grid.innerHTML = '';
  productsList.filter(p => p.name.toLowerCase().includes(filter.toLowerCase())).forEach(p => {
    grid.innerHTML += `
      <div onclick="addToCart('${p.name}', ${p.price})" class="border rounded-lg p-3 hover:border-blue-500 cursor-pointer flex flex-col justify-between bg-white h-24">
        <p class="text-[11px] font-semibold leading-tight">${p.name}</p>
        <div class="flex justify-between items-end mt-2">
          <span class="text-[10px] text-slate-500 font-bold">Stok: ${p.stock}</span>
          <span class="text-sm font-bold text-blue-600">${Number(p.price).toFixed(2)} ₼</span>
        </div>
      </div>`;
  });
}

function filterProducts() {
  renderProducts(document.getElementById('productSearch').value);
}

function renderStockTable() {
  const tbody = document.getElementById('stockTableBody');
  if(!tbody) return;
  tbody.innerHTML = '';
  productsList.forEach(p => {
    tbody.innerHTML += `<tr class="border-b"><td class="p-2">${p.name}</td><td class="p-2 font-bold text-center">${p.stock}</td><td class="p-2 text-right">${Number(p.price).toFixed(2)} ₼</td></tr>`;
  });
}

// 1. PƏNCƏRƏNİ AÇMAQ ÜÇÜN
function addToCart(name, price) {
  tempProduct = productsList.find(x => x.name === name);
  document.getElementById('addProdName').innerText = tempProduct.name;
  document.getElementById('addProdMaxStock').innerText = tempProduct.stock;
  document.getElementById('addProdQty').value = 1;
  document.getElementById('addProdPrice').value = price;
  document.getElementById('addProductModal').classList.remove('hidden');
}

// 2. TƏSDİQ EDİB SƏBƏTƏ YAZMAQ
function confirmAddToCart() {
  if (!tempProduct) return;
  const qty = parseFloat(document.getElementById('addProdQty').value);
  const price = parseFloat(document.getElementById('addProdPrice').value);
  
  if (isNaN(qty) || qty <= 0) return alert("Miqdarı düzgün daxil edin!");
  if (isNaN(price) || price < 0) return alert("Qiyməti düzgün daxil edin!");
  
  const existing = cart.find(i => i.name === tempProduct.name);
  const currentQty = existing ? existing.qty : 0;
  
  if (currentQty + qty > tempProduct.stock) return alert("Anbarda kifayət qədər məhsul yoxdur!");
  
  if (existing) {
    existing.qty += qty;
    existing.price = price;
  } else {
    cart.push({ name: tempProduct.name, price: price, qty: qty });
  }
  
  closeModal('addProductModal');
  renderCart();
}

function changeQty(index, delta) {
  const item = cart[index];
  const p = productsList.find(x => x.name === item.name);
  if (delta > 0 && item.qty + delta > p.stock) return alert("Kifayət qədər stok yoxdur!");
  item.qty += delta;
  if (item.qty <= 0) cart.splice(index, 1);
  renderCart();
}

// 3. SƏBƏTİ VƏ ENDİRİMİ HESABLAMAQ
function renderCart() {
  const cont = document.getElementById('cartItems');
  if(!cont) return;
  if (cart.length === 0) {
    cont.innerHTML = '<div class="text-center py-8 text-slate-400 text-xs">Səbət boşdur</div>'; 
    document.getElementById('cartTotal').innerText = '0.00 ₼';
    return;
  }
  
  cont.innerHTML = '';
  let subTotal = 0;
  
  cart.forEach((item, idx) => {
    let itemTotal = item.qty * item.price;
    subTotal += itemTotal;
    cont.innerHTML += `
      <div class="bg-white p-2 border rounded mb-2">
        <div class="flex justify-between"><p class="text-[11px] font-bold">${item.name}</p><button onclick="changeQty(${idx}, -item.qty)" class="text-rose-500 text-xs px-1">✕</button></div>
        <div class="flex justify-between items-center mt-2">
          <span class="text-[11px] text-blue-600 font-bold">${item.price.toFixed(2)} ₼</span>
          <div class="flex gap-2 bg-slate-50 border rounded px-1"><button onclick="changeQty(${idx}, -1)" class="px-2">-</button><span class="text-xs font-bold pt-0.5">${item.qty}</span><button onclick="changeQty(${idx}, 1)" class="px-2">+</button></div>
        </div>
      </div>`;
  });
  
  // Endirimi çıxmaq
  const discountVal = parseFloat(document.getElementById('saleDiscount').value) || 0;
  const finalTotal = subTotal - discountVal;
  
  document.getElementById('cartTotal').innerText = (finalTotal > 0 ? finalTotal : 0).toFixed(2) + ' ₼';
}

async function processSale() {
  if (cart.length === 0) return alert("Səbət boşdur!");
  const totalAmt = parseFloat(document.getElementById('cartTotal').innerText);
  if(totalAmt <= 0 && cart.length > 0) return alert("Endirim səbətin dəyərindən çox ola bilməz!");
  
  const custName = document.getElementById('custName').value || 'Nağd Müştəri';
  const payMethod = document.getElementById('payMethod').value;
  const invoiceNo = "INV-" + Date.now().toString().slice(-6);
  const saleDate = new Date().toLocaleString('az-AZ');

  const payload = {
    action: "ADD_SALE", date: saleDate, user: currentUser.name, customer: custName,
    paymentType: payMethod, invoiceNo: invoiceNo, totalAmount: totalAmt,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  document.getElementById('invTotal').innerText = totalAmt.toFixed(2) + ' ₼';
  await sendToGoogleSheets(payload);
  
  document.getElementById('invoiceModal').classList.remove('hidden');
  cart = []; 
  document.getElementById('custName').value = '';
  document.getElementById('saleDiscount').value = '';
  loadDataFromSheets();
}

async function processStockIn() {
  const name = document.getElementById('stockProdName').value.trim();
  const qty = parseInt(document.getElementById('stockQty').value);
  if (!name || !qty) return;
  const stockDate = new Date().toLocaleString('az-AZ');
  
  const payload = {
    action: "ADD_STOCK", date: stockDate, user: currentUser.name, supplier: "-", items: [{ name: name, qty: qty }]
  };
  await sendToGoogleSheets(payload);
  closeModal('stockModal');
  loadDataFromSheets();
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value.trim();
  const amount = parseFloat(document.getElementById('expAmount').value);
  if (!desc || isNaN(amount) || amount <= 0) return;
  const expDate = new Date().toLocaleString('az-AZ');
  
  const payload = { action: "ADD_EXPENSE", date: expDate, user: currentUser.name, description: desc, amount: amount, paymentType: "Nağd" };
  await sendToGoogleSheets(payload);
  closeModal('expenseModal');
  loadDataFromSheets();
}

function renderReportsTable() {
  const tbody = document.getElementById('allTransactionsTableBody');
  tbody.innerHTML = '';
  [...transactionsList].reverse().forEach(trx => {
    tbody.innerHTML += `<tr class="border-b"><td class="p-2">${trx.date.slice(0,10)}</td><td class="p-2 text-[10px] font-bold">${trx.type}</td><td class="p-2">${trx.product}</td><td class="p-2 text-right font-bold">${trx.total !== "-" ? Number(trx.total).toFixed(2) + " ₼" : "-"}</td></tr>`;
  });
}

function renderDashboardStats() {
  const todayStr = new Date().toLocaleDateString();
  let sales = 0, expenses = 0;
  transactionsList.forEach(trx => {
    if(trx.date && trx.date.includes(todayStr.slice(0, 5))) {
      if(trx.type === "Satış") sales += Number(trx.total) || 0;
      if(trx.type === "Xərc") expenses += Number(trx.total) || 0;
    }
  });
  document.getElementById('dashSales').innerText = sales.toFixed(2) + " ₼";
  document.getElementById('dashExpenses').innerText = expenses.toFixed(2) + " ₼";
  document.getElementById('dashBalance').innerText = (sales - expenses).toFixed(2) + " ₼";
}

function dayEndReport() {
  renderDashboardStats();
  document.getElementById('deSales').innerText = document.getElementById('dashSales').innerText;
  document.getElementById('deExpenses').innerText = document.getElementById('dashExpenses').innerText;
  document.getElementById('deNet').innerText = document.getElementById('dashBalance').innerText;
  document.getElementById('dayEndModal').classList.remove('hidden');
}

async function sendToGoogleSheets(payload) {
  try {
    await fetch(APPS_SCRIPT_URL, { method: "POST", mode: "no-cors", headers: { "Content-Type": "text/plain" }, body: JSON.stringify(payload) });
    showToast("Gözləyin, məlumat yenilənir...", "emerald");
  } catch (err) {}
}

function showToast(msg, color="emerald") {
  const t = document.getElementById('toast');
  document.getElementById('toast-msg').innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${color}-500`;
  t.classList.remove('-translate-y-20', 'opacity-0');
  setTimeout(() => t.classList.add('-translate-y-20', 'opacity-0'), 3000);
}

function closeModal(id) { document.getElementById(id).classList.add('hidden'); }
