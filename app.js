const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycby1D6XyupIuM0YNFvd2TVHZ-ErphAePKpeATZDV-ja0Fy6mEmhZDCaiHC1IwmsC8S-QHw/exec";

let currentUser = null; 
let cart = [];
let productsList = [];
let transactionsList = [];
let globalDiscount = 0;

document.addEventListener("DOMContentLoaded", () => {
  loadDataFromSheets();
});

async function loadDataFromSheets() {
  showToast("DivarPanel_Final_Sablon bazasından yüklənir...", "blue");
  try {
    const response = await fetch(APPS_SCRIPT_URL, {
      method: "GET",
      redirect: "follow"
    });
    
    const textData = await response.text();
    let data;
    try {
      data = JSON.parse(textData);
    } catch(parseErr) {
      console.error("JSON parse xətası:", textData);
      throw new Error("Giriş və ya icazə xətası");
    }

    if(data && data.status === "success") {
      productsList = data.products || [];
      transactionsList = data.transactions || [];
      renderProducts();
      renderStockTable();
      renderReportsTable();
      renderDashboardStats();
      showToast("Baza ilə uğurla sinxronlaşdırıldı!", "emerald");
    } else {
      showToast("Bazadan məlumat oxunmadı.", "rose");
    }
  } catch(err) {
    console.error(err);
    showToast("Bazaya qoşulma xətası! İnterneti yoxlayın.", "rose");
  }
}

function login() {
  const pinInput = document.getElementById('pinInput');
  if (!pinInput) return;
  const pin = pinInput.value.trim();
  
  if (pin === '3285') { currentUser = { name: 'Bəhram', role: 'admin' }; } 
  else if (pin === '2255') { currentUser = { name: 'Sadiq', role: 'staff' }; } 
  else { 
    const err = document.getElementById('loginError');
    if(err) err.classList.remove('hidden'); 
    return; 
  }
  
  document.getElementById('loginScreen').classList.add('hidden');
  document.getElementById('activeUser').innerText = currentUser.name;
  document.getElementById('mobileActiveUser').innerText = currentUser.name;
  document.getElementById('userInitial').innerText = currentUser.name.charAt(0);
  document.querySelectorAll('.cart-user-name').forEach(el => el.innerText = currentUser.name);
  
  if (currentUser.role === 'admin') {
    document.querySelectorAll('.admin-only').forEach(el => el.classList.remove('hidden'));
  }
  nav('dashboard');
  loadDataFromSheets();
}

function logout() {
  currentUser = null;
  document.getElementById('pinInput').value = '';
  document.getElementById('loginScreen').classList.remove('hidden');
  document.querySelectorAll('.admin-only').forEach(el => el.classList.add('hidden'));
}

function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  const targetView = document.getElementById('view-' + target);
  if(targetView) targetView.classList.remove('hidden');
  
  document.querySelectorAll('.nav-btn').forEach(btn => {
    if (btn.dataset.target === target) {
      btn.classList.add('text-blue-600', 'font-bold');
      if(window.innerWidth >= 768) {
        btn.classList.add('bg-slate-800', 'text-white');
      }
    } else {
      btn.classList.remove('text-blue-600', 'bg-slate-800', 'text-white', 'font-bold');
      btn.classList.add('text-slate-500');
    }
  });
}

function renderProducts(filter = "") {
  const grid = document.getElementById('posProductGrid');
  if(!grid) return;
  grid.innerHTML = '';
  productsList.filter(p => p.name.toLowerCase().includes(filter.toLowerCase())).forEach(p => {
    grid.innerHTML += `
      <div onclick="addToCart('${p.name}', ${p.price})" class="border rounded-lg p-3 hover:border-blue-500 cursor-pointer flex flex-col justify-between h-24 bg-white shadow-sm">
        <p class="text-xs font-semibold leading-tight line-clamp-2">${p.name}</p>
        <div class="flex justify-between items-end mt-2">
          <span class="text-[10px] text-slate-500 font-bold">Stok: ${p.stock}</span>
          <span class="text-sm font-bold text-blue-600">${Number(p.price).toFixed(2)} ₼</span>
        </div>
      </div>
    `;
  });
}

function filterProducts() {
  const searchInput = document.getElementById('productSearch');
  if(searchInput) renderProducts(searchInput.value);
}

function renderStockTable() {
  const tbody = document.getElementById('stockTableBody');
  if(!tbody) return;
  tbody.innerHTML = '';
  productsList.forEach(p => {
    tbody.innerHTML += `
      <tr class="border-b">
        <td class="p-3 font-medium">${p.name}</td>
        <td class="p-3 text-center font-bold text-blue-600">${p.stock}</td>
        <td class="p-3 text-right">${Number(p.price).toFixed(2)} ₼</td>
      </tr>
    `;
  });
}

function addToCart(name, price) {
  const p = productsList.find(x => x.name === name);
  const existing = cart.find(i => i.name === name);
  const currentQty = existing ? existing.qty : 0;
  
  if (currentQty + 1 > p.stock) {
    alert("Anbarda kifayət qədər məhsul yoxdur!");
    return;
  }
  
  if (existing) { existing.qty++; } else { cart.push({ name, price: Number(price), qty: 1 }); }
  renderCart();
}

function changeQty(index, delta) {
  const item = cart[index];
  const p = productsList.find(x => x.name === item.name);
  
  if (delta > 0 && item.qty + delta > p.stock) {
    alert("Anbarda kifayət qədər məhsul yoxdur!");
    return;
  }
  
  item.qty += delta;
  if (item.qty <= 0) cart.splice(index, 1);
  renderCart();
}

function updateCartItemPrice(index, newPrice) {
  const price = parseFloat(newPrice);
  if (isNaN(price) || price < 0) return;
  cart[index].price = price;
  renderCart();
}

function updateDiscount(val) {
  globalDiscount = parseFloat(val) || 0;
  renderCart();
}

function renderCart() {
  const cont = document.getElementById('cartItems');
  const empty = document.getElementById('emptyCart');
  if(!cont) return;
  
  if (cart.length === 0) {
    cont.innerHTML = ''; 
    if(empty) { cont.appendChild(empty); empty.classList.remove('hidden'); }
    const cartTotal = document.getElementById('cartTotal');
    if(cartTotal) cartTotal.innerText = '0.00 ₼';
    return;
  }
  if(empty) empty.classList.add('hidden'); 
  cont.innerHTML = '';
  let subtotal = 0;
  
  cart.forEach((item, idx) => {
    let itemTotal = item.qty * item.price;
    subtotal += itemTotal;
    
    cont.innerHTML += `
      <div class="bg-white p-2.5 rounded-xl border flex flex-col gap-2 shadow-sm mb-2">
        <div class="flex justify-between items-center">
          <p class="text-xs font-semibold text-slate-700 leading-tight">${item.name}</p>
          <button type="button" onclick="changeQty(${idx}, -item.qty)" class="text-rose-500 text-xs font-bold px-1.5 py-0.5 hover:bg-rose-50 rounded">✕</button>
        </div>
        <div class="flex justify-between items-center">
          <div class="flex items-center gap-1.5">
            <span class="text-[10px] text-slate-500">Qiymət (₼):</span>
            <input type="number" step="0.01" value="${item.price}" onchange="updateCartItemPrice(${idx}, this.value)" class="w-20 text-xs font-bold text-blue-600 border rounded-lg px-1.5 py-1 text-center bg-slate-50 focus:bg-white focus:border-blue-500">
          </div>
          <div class="flex items-center gap-2 bg-slate-50 p-1 rounded-lg border">
            <button type="button" onclick="changeQty(${idx}, -1)" class="w-6 h-6 bg-white shadow-sm rounded-md text-xs font-bold">-</button>
            <span class="text-xs font-bold w-4 text-center">${item.qty}</span>
            <button type="button" onclick="changeQty(${idx}, 1)" class="w-6 h-6 bg-white shadow-sm rounded-md text-xs font-bold">+</button>
          </div>
        </div>
      </div>
    `;
  });
  
  let finalTotal = subtotal - globalDiscount;
  if(finalTotal < 0) finalTotal = 0;

  const cartTotal = document.getElementById('cartTotal');
  if(cartTotal) cartTotal.innerText = finalTotal.toFixed(2) + ' ₼';
}

async function processSale() {
  if (cart.length === 0) return alert("Səbət boşdur!");
  const custName = document.getElementById('custName').value || 'Nağd Müştəri';
  const payMethod = document.getElementById('payMethod').value;
  const totalAmt = parseFloat(document.getElementById('cartTotal').innerText);
  const invoiceNo = "INV-" + Date.now().toString().slice(-6);
  const saleDate = new Date().toLocaleString('az-AZ');

  cart.forEach(i => {
    const p = productsList.find(x => x.name === i.name);
    if(p) p.stock -= i.qty;
  });

  const payload = {
    action: "ADD_SALE",
    date: saleDate, user: currentUser ? currentUser.name : 'Bəhram', customer: custName,
    paymentType: payMethod, invoiceNo: invoiceNo, totalAmount: totalAmt,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  cart.forEach(i => {
    transactionsList.push({
      date: saleDate, type: "Satış", user: currentUser.name, target: custName,
      product: i.name, qty: i.qty, price: i.price, total: i.qty * i.price, payment: payMethod, invoice: invoiceNo
    });
  });

  document.getElementById('invCust').innerText = custName;
  document.getElementById('invUser').innerText = currentUser.name;
  document.getElementById('invTotal').innerText = totalAmt.toFixed(2) + ' ₼';
  
  const tbody = document.getElementById('invItemsTable');
  if(tbody) {
    tbody.innerHTML = '';
    cart.forEach(item => {
      tbody.innerHTML += `<tr><td class="py-1">${item.name}</td><td class="text-center">${item.qty}</td><td class="text-right">${(item.price * item.qty).toFixed(2)}</td></tr>`;
    });
  }

  await sendToGoogleSheets(payload);
  document.getElementById('invoiceModal').classList.remove('hidden');
  cart = []; 
  globalDiscount = 0;
  document.getElementById('custName').value = '';
  const discInp = document.getElementById('discountInput');
  if(discInp) discInp.value = '';
  renderCart(); renderProducts(); renderStockTable(); renderReportsTable(); renderDashboardStats();
}

async function processStockIn() {
  const name = document.getElementById('stockProdName').value.trim();
  const qty = parseInt(document.getElementById('stockQty').value);
  if (!name || !qty) return alert("Məlumatları doldurun!");

  const stockDate = new Date().toLocaleString('az-AZ');
  let p = productsList.find(x => x.name.toLowerCase() === name.toLowerCase());
  if(p) { p.stock += qty; } 
  else { productsList.push({ name: name, price: 50.00, stock: qty }); }

  transactionsList.push({
    date: stockDate, type: "Mədaxil (Anbar)", user: currentUser.name, target: document.getElementById('stockSupplier').value,
    product: name, qty: qty, price: "-", total: "-", payment: "Köçürmə", invoice: "-"
  });

  const payload = {
    action: "ADD_STOCK",
    date: stockDate,
    user: currentUser.name, supplier: document.getElementById('stockSupplier').value,
    items: [{ name: name, qty: qty }]
  };

  await sendToGoogleSheets(payload);
  document.getElementById('stockProdName').value = '';
  document.getElementById('stockQty').value = '';
  renderProducts(); renderStockTable(); renderReportsTable();
  alert("Mal uğurla əlavə olundu və bazaya yazıldı!");
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value.trim();
  const amount = parseFloat(document.getElementById('expAmount').value);
  
  if (!desc || isNaN(amount) || amount <= 0) {
    alert("Zəhmət olmasa təyinat və məbləği düzgün daxil edin!");
    return;
  }

  const expDate = new Date().toLocaleString('az-AZ');
  const payMethod = document.getElementById('expMethod').value;

  transactionsList.push({
    date: expDate, type: "Xərc", user: currentUser.name, target: "-",
    product: desc, qty: 1, price: amount, total: amount, payment: payMethod, invoice: "-"
  });

  const payload = {
    action: "ADD_EXPENSE",
    date: expDate,
    user: currentUser.name, description: desc, amount: amount, paymentType: payMethod
  };

  closeModal('expenseModal');
  document.getElementById('expDesc').value = '';
  document.getElementById('expAmount').value = '';

  await sendToGoogleSheets(payload);
  renderReportsTable(); renderDashboardStats();
}

function renderReportsTable() {
  const tbody = document.getElementById('allTransactionsTableBody');
  if(!tbody) return;
  if(transactionsList.length === 0) {
    tbody.innerHTML = `<tr><td colspan="8" class="p-4 text-center text-slate-400">Heç bir əməliyyat yoxdur.</td></tr>`;
    return;
  }
  tbody.innerHTML = '';
  [...transactionsList].reverse().forEach(trx => {
    let badgeColor = "bg-blue-100 text-blue-700";
    if(trx.type === "Satış") badgeColor = "bg-emerald-100 text-emerald-700";
    if(trx.type === "Xərc") badgeColor = "bg-rose-100 text-rose-700";
    if(trx.type.includes("Mədaxil")) badgeColor = "bg-amber-100 text-amber-700";

    tbody.innerHTML += `
      <tr class="border-b hover:bg-slate-50">
        <td class="p-2.5 text-slate-500">${trx.date}</td>
        <td class="p-2.5"><span class="px-2 py-0.5 rounded-full text-[10px] font-bold ${badgeColor}">${trx.type}</span></td>
        <td class="p-2.5">${trx.user}</td>
        <td class="p-2.5">${trx.target}</td>
        <td class="p-2.5 font-medium">${trx.product}</td>
        <td class="p-2.5 text-center">${trx.qty}</td>
        <td class="p-2.5 text-right font-bold">${trx.total !== "-" ? Number(trx.total).toFixed(2) + " ₼" : "-"}</td>
        <td class="p-2.5 text-slate-500">${trx.payment}</td>
      </tr>
    `;
  });
}

function renderDashboardStats() {
  const todayStr = new Date().toLocaleDateString();
  const dateElem = document.getElementById('todayDateStr');
  if(dateElem) dateElem.innerText = new Date().toLocaleDateString('az-AZ');

  let todaySalesTotal = 0;
  let todayExpensesTotal = 0;
  let todaySalesItems = [];

  transactionsList.forEach(trx => {
    if(trx.date && trx.date.includes(todayStr.slice(0, 5))) {
      if(trx.type === "Satış") {
        todaySalesTotal += Number(trx.total) || 0;
        todaySalesItems.push(trx);
      } else if(trx.type === "Xərc") {
        todayExpensesTotal += Number(trx.total) || 0;
      }
    }
  });

  const dashSales = document.getElementById('dashSales');
  const dashExpenses = document.getElementById('dashExpenses');
  const dashBalance = document.getElementById('dashBalance');

  if(dashSales) dashSales.innerText = todaySalesTotal.toFixed(2) + " ₼";
  if(dashExpenses) dashExpenses.innerText = todayExpensesTotal.toFixed(2) + " ₼";
  if(dashBalance) dashBalance.innerText = (todaySalesTotal - todayExpensesTotal).toFixed(2) + " ₼";

  const todayTableBody = document.getElementById('todaySalesTableBody');
  if(todayTableBody) {
    if(todaySalesItems.length === 0) {
      todayTableBody.innerHTML = `<tr><td colspan="5" class="p-4 text-center text-slate-400">Bugünkü satış qeydə alınmayıb.</td></tr>`;
    } else {
      todayTableBody.innerHTML = '';
      [...todaySalesItems].reverse().forEach(item => {
        todayTableBody.innerHTML += `
          <tr class="border-b">
            <td class="p-2.5 text-slate-500">${item.date}</td>
            <td class="p-2.5 font-medium">${item.product}</td>
            <td class="p-2.5 text-center">${item.qty}</td>
            <td class="p-2.5 text-right">${Number(item.price).toFixed(2)} ₼</td>
            <td class="p-2.5 text-right font-bold text-emerald-600">${Number(item.total).toFixed(2)} ₼</td>
          </tr>
        `;
      });
    }
  }
}

function dayEndReport() {
  const todayStr = new Date().toLocaleDateString();
  let sales = 0, expenses = 0;
  
  transactionsList.forEach(trx => {
    if(trx.date && trx.date.includes(todayStr.slice(0, 5))) {
      if(trx.type === "Satış") sales += Number(trx.total) || 0;
      if(trx.type === "Xərc") expenses += Number(trx.total) || 0;
    }
  });

  document.getElementById('dayEndModalDate').innerText = new Date().toLocaleDateString('az-AZ', { year: 'numeric', month: 'long', day: 'numeric' });
  document.getElementById('deSales').innerText = sales.toFixed(2) + " ₼";
  document.getElementById('deExpenses').innerText = expenses.toFixed(2) + " ₼";
  document.getElementById('deNet').innerText = (sales - expenses).toFixed(2) + " ₼";
  document.getElementById('dayEndModal').classList.remove('hidden');
}

async function sendToGoogleSheets(payload) {
  try {
    await fetch(APPS_SCRIPT_URL, { 
      method: "POST", 
      mode: "no-cors", 
      headers: { "Content-Type": "text/plain" }, 
      body: JSON.stringify(payload) 
    });
    showToast("Bazaya uğurla yazıldı!", "emerald");
  } catch (err) {
    showToast("Xəta baş verdi!", "rose");
  }
}

function showToast(msg, color="emerald") {
  const t = document.getElementById('toast');
  if(!t) return;
  const msgElem = document.getElementById('toast-msg');
  if(msgElem) msgElem.innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${color}-500`;
  t.classList.remove('-translate-y-20', 'opacity-0');
  setTimeout(() => t.classList.add('-translate-y-20', 'opacity-0'), 3000);
}

function closeModal(id) { 
  const modal = document.getElementById(id);
  if(modal) modal.classList.add('hidden'); 
}

function sendWhatsApp() {
  const invTotal = document.getElementById('invTotal');
  const totalVal = invTotal ? invTotal.innerText : '0.00 ₼';
  window.open(`https://wa.me/?text=DecorConcept%20Qaiməsi%20-%20Yekun:%20${totalVal}`, '_blank');
}

function downloadExcel() {
  window.location.href = "DivarPanel_Final_Sablon.xlsx";
}
