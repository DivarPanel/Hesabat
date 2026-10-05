const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycby1D6XyupIuM0YNFvd2TVHZ-ErphAePKpeATZDV-ja0Fy6mEmhZDCaiHC1IwmsC8S-QHw/exec";

let currentUser = null; 
let cart = []; 
let productsList = []; 
let transactionsList = []; 
let tempProduct = null;
let currentViewingInvoice = null; 
let editingInvoiceNo = null;

function parseCustomDate(rawDate) {
  let d = new Date(rawDate);
  if(isNaN(d)) return rawDate;
  let day = String(d.getDate()).padStart(2, '0');
  let month = String(d.getMonth() + 1).padStart(2, '0');
  let year = d.getFullYear();
  let hr = String(d.getHours()).padStart(2, '0');
  let min = String(d.getMinutes()).padStart(2, '0');
  return `${day}.${month}.${year}, ${hr}:${min}`;
}

function getTodayStr() {
  const d = new Date();
  return `${String(d.getDate()).padStart(2,'0')}.${String(d.getMonth()+1).padStart(2,'0')}.${d.getFullYear()}`;
}

document.addEventListener("DOMContentLoaded", () => { 
  loadDataFromSheets(); 
});

async function loadDataFromSheets() {
  showToast("Yüklənir...", "blue");
  try {
    const response = await fetch(APPS_SCRIPT_URL, { method: "GET", redirect: "follow" });
    let text = await response.text();
    let data = JSON.parse(text);

    if(data.status === "success") {
      productsList = data.products || [];
      transactionsList = (data.transactions || []).map(t => {
        if(t.date && (t.date.includes("T") || t.date.includes("-"))) {
          t.date = parseCustomDate(t.date);
        }
        return t;
      });
      renderProducts(); 
      renderStockTable(); 
      renderReportsTable(); 
      renderDashboardStats(); 
      renderCustomers();
      showToast("Sinxronlaşdırıldı!", "emerald");
    }
  } catch(err) { 
    showToast("Bağlantı xətası.", "rose"); 
  }
}

function login() {
  const pin = document.getElementById('pinInput').value.trim();
  if (pin === '3285') { currentUser = { name: 'Bəhram', role: 'admin' }; } 
  else if (pin === '2255') { currentUser = { name: 'Sadiq', role: 'staff' }; } 
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

// SƏHİFƏLƏR ARASI KEÇİD (Həm masaüstü, həm də mobil üçün)
function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  const targetView = document.getElementById('view-' + target);
  if(targetView) targetView.classList.remove('hidden');
  
  // Bütün nav düymələrinin rənglərini tənzimləyirik
  document.querySelectorAll('.nav-btn').forEach(btn => {
    if(btn.dataset.target === target) {
      btn.classList.add('text-blue-600', 'font-bold');
      btn.classList.remove('text-slate-500');
    } else {
      btn.classList.remove('text-blue-600', 'font-bold');
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
      <div onclick="addToCart('${p.name}', ${p.price})" class="border rounded-xl p-2.5 hover:border-blue-500 cursor-pointer flex flex-col justify-between bg-white h-20 shadow-sm active:scale-95 transition-transform">
        <p class="text-[11px] font-bold leading-tight line-clamp-2">${p.name}</p>
        <div class="flex justify-between items-end mt-1">
          <span class="text-[10px] text-slate-400 font-semibold">Stok: ${p.stock}</span>
          <span class="text-xs font-bold text-blue-600">${Number(p.price).toFixed(2)} ₼</span>
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
    tbody.innerHTML += `<tr class="border-b"><td class="p-3 font-medium">${p.name}</td><td class="p-3 font-bold text-center">${p.stock}</td><td class="p-3 text-right font-bold text-blue-600">${Number(p.price).toFixed(2)} ₼</td></tr>`; 
  });
}

function renderCustomers() {
  const filter = (document.getElementById('custSearch') ? document.getElementById('custSearch').value.toLowerCase() : "");
  const tbody = document.getElementById('customersTableBody'); 
  if(!tbody) return;
  const custMap = {};
  
  transactionsList.forEach(t => {
    if(t.type === "Satış" && t.target && t.target !== "-" && t.target !== "Nağd Müştəri") {
      let cName = t.target.trim();
      if(!custMap[cName]) custMap[cName] = { name: cName, count: 0, total: 0, invoices: new Set() };
      custMap[cName].invoices.add(t.invoice);
      custMap[cName].total += Number(t.total);
    }
  });

  const arr = Object.values(custMap).filter(c => c.name.toLowerCase().includes(filter)).sort((a,b) => b.total - a.total);
  tbody.innerHTML = arr.length === 0 ? `<tr><td colspan="3" class="text-center p-4 text-slate-400">Müştəri tapılmadı</td></tr>` : '';
  arr.forEach(c => {
    tbody.innerHTML += `<tr class="border-b"><td class="p-3 font-bold">${c.name}</td><td class="p-3 text-center">${c.invoices.size} dəfə</td><td class="p-3 text-right font-bold text-emerald-600">${c.total.toFixed(2)} ₼</td></tr>`;
  });
}

function addToCart(name, price) {
  tempProduct = productsList.find(x => x.name === name);
  document.getElementById('addProdName').innerText = tempProduct.name;
  document.getElementById('addProdMaxStock').innerText = tempProduct.stock;
  document.getElementById('addProdQty').value = 1; 
  document.getElementById('addProdPrice').value = price;
  document.getElementById('addProductModal').classList.remove('hidden');
}

function confirmAddToCart() {
  if (!tempProduct) return;
  const qty = parseFloat(document.getElementById('addProdQty').value); 
  const price = parseFloat(document.getElementById('addProdPrice').value);
  if (isNaN(qty) || qty <= 0 || isNaN(price) || price < 0) return alert("Düzgün yazın!");
  
  const existing = cart.find(i => i.name === tempProduct.name);
  if (!editingInvoiceNo && (existing ? existing.qty : 0) + qty > tempProduct.stock) return alert("Anbarda kifayət qədər məhsul yoxdur!");
  
  if (existing) { existing.qty += qty; existing.price = price; } 
  else { cart.push({ name: tempProduct.name, price: price, qty: qty }); }
  
  closeModal('addProductModal'); 
  renderCart();
}

function changeQty(index, delta) {
  const item = cart[index]; 
  const p = productsList.find(x => x.name === item.name);
  if (!editingInvoiceNo && delta > 0 && item.qty + delta > p.stock) return alert("Stok çatmır!");
  item.qty += delta; 
  if (item.qty <= 0) cart.splice(index, 1); 
  renderCart();
}

function renderCart() {
  const cont = document.getElementById('cartItems');
  if(!cont) return;
  if (cart.length === 0) {
    cont.innerHTML = '<div class="text-center py-6 text-slate-400 text-xs">Səbət boşdur</div>'; 
    document.getElementById('cartTotal').innerText = '0.00 ₼'; 
    return;
  }
  cont.innerHTML = ''; let subTotal = 0;
  cart.forEach((item, idx) => {
    subTotal += item.qty * item.price;
    cont.innerHTML += `
      <div class="bg-slate-50 p-2 border rounded-xl mb-1.5 flex justify-between items-center">
        <div>
          <p class="text-[11px] font-bold text-slate-800">${item.name}</p>
          <span class="text-[10px] text-blue-600 font-bold">${item.price.toFixed(2)} ₼ x ${item.qty}</span>
        </div>
        <div class="flex items-center gap-1.5">
          <button onclick="changeQty(${idx}, -1)" class="w-6 h-6 bg-white border rounded font-bold">-</button>
          <span class="text-xs font-bold w-4 text-center">${item.qty}</span>
          <button onclick="changeQty(${idx}, 1)" class="w-6 h-6 bg-white border rounded font-bold">+</button>
          <button onclick="changeQty(${idx}, -${item.qty})" class="text-rose-500 text-xs ml-1 px-1">✕</button>
        </div>
      </div>`;
  });
  const discountVal = parseFloat(document.getElementById('saleDiscount').value) || 0;
  document.getElementById('cartTotal').innerText = Math.max(0, subTotal - discountVal).toFixed(2) + ' ₼';
}

async function processSale() {
  if (cart.length === 0) return alert("Səbət boşdur!");
  const totalAmt = parseFloat(document.getElementById('cartTotal').innerText);
  const discountVal = parseFloat(document.getElementById('saleDiscount').value) || 0;
  const custName = document.getElementById('custName').value || 'Nağd Müştəri';
  const custPhone = document.getElementById('custPhone').value.trim();
  const finalCust = custPhone ? `${custName} - ${custPhone}` : custName;
  const payM = document.getElementById('payMethod').value;
  const isEditing = !!editingInvoiceNo;
  const invoiceNo = isEditing ? editingInvoiceNo : "INV-" + Date.now().toString().slice(-6);
  const saleDate = parseCustomDate(new Date());

  const payload = {
    action: isEditing ? "EDIT_SALE" : "ADD_SALE", 
    date: saleDate, user: currentUser.name, customer: finalCust, paymentType: payM,
    invoiceNo: invoiceNo, totalAmount: totalAmt, discount: discountVal,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  sendToGoogleSheets(payload); 
  cancelEdit(true); 
  setTimeout(() => loadDataFromSheets(), 1500);
  
  if(!isEditing) {
    cart.forEach(i => { transactionsList.push({ date: saleDate, type: "Satış", user: currentUser.name, target: finalCust, product: i.name, qty: i.qty, price: i.price, total: i.qty * i.price, payment: payM, invoice: invoiceNo }); });
    if(discountVal > 0) transactionsList.push({ date: saleDate, type: "Endirim", user: currentUser.name, target: finalCust, product: "Satış Endirimi", qty: 1, price: -discountVal, total: -discountVal, payment: payM, invoice: invoiceNo });
    viewInvoiceDetails(invoiceNo);
  }
}

function editInvoice() {
  if (!currentViewingInvoice) return;
  const group = transactionsList.filter(t => t.invoice === currentViewingInvoice);
  if(group.length === 0) return;
  editingInvoiceNo = currentViewingInvoice; cart = []; let discount = 0; let customerStr = group[0].target; let payM = group[0].payment;
  
  group.forEach(t => {
    if (t.type === "Satış") cart.push({ name: t.product, price: Number(t.price), qty: Number(t.qty) });
    else if (t.type === "Endirim") discount = Math.abs(Number(t.total));
  });
  let custName = customerStr; let custPhone = "";
  if (customerStr.includes(" - ")) { let parts = customerStr.split(" - "); custName = parts[0]; custPhone = parts[1]; }
  
  document.getElementById('custName').value = custName; 
  document.getElementById('custPhone').value = custPhone;
  document.getElementById('saleDiscount').value = discount > 0 ? discount : ''; 
  document.getElementById('payMethod').value = payM;
  
  const btn = document.getElementById('processSaleBtn'); 
  btn.innerText = "Dəyişikliyi Yadda Saxla"; 
  btn.classList.replace('bg-emerald-600', 'bg-blue-600');
  document.getElementById('cancelEditBtn').classList.remove('hidden');
  
  closeInvoiceModal(); 
  nav('pos'); 
  renderCart();
}

function cancelEdit() {
  editingInvoiceNo = null; cart = []; 
  document.getElementById('custName').value = ''; 
  document.getElementById('custPhone').value = ''; 
  document.getElementById('saleDiscount').value = '';
  const btn = document.getElementById('processSaleBtn'); 
  btn.innerText = "Qaimə Yarat & Təsdiqlə"; 
  btn.classList.replace('bg-blue-600', 'bg-emerald-600');
  document.getElementById('cancelEditBtn').classList.add('hidden'); 
  renderCart();
}

function viewInvoiceDetails(invNo) {
  const group = transactionsList.filter(t => t.invoice === invNo); 
  if(group.length === 0) return;
  currentViewingInvoice = invNo; let subTotal = 0, discount = 0, itemsHtml = '';
  
  group.forEach(t => {
      if(t.type === "Endirim") discount = Math.abs(Number(t.total));
      else if (t.type === "Satış") {
          subTotal += Number(t.total);
          itemsHtml += `<tr><td class="py-1.5 border-b">${t.product}</td><td class="text-center border-b">${t.qty}</td><td class="text-right font-bold border-b">${Number(t.total).toFixed(2)}</td></tr>`;
      }
  });
  
  document.getElementById('viewInvNo').innerText = "№ " + invNo; 
  document.getElementById('viewInvDate').innerText = group[0].date;
  document.getElementById('viewInvCust').innerText = group[0].target; 
  document.getElementById('viewInvUser').innerText = group[0].user;
  document.getElementById('viewInvPay').innerText = group[0].payment; 
  document.getElementById('viewInvItems').innerHTML = itemsHtml;
  document.getElementById('viewInvSubTotal').innerText = subTotal.toFixed(2) + ' ₼';
  document.getElementById('viewInvDiscount').innerText = discount > 0 ? '-' + discount.toFixed(2) + ' ₼' : '0.00 ₼';
  document.getElementById('viewInvTotal').innerText = (subTotal - discount).toFixed(2) + ' ₼';
  
  const adminBtns = document.getElementById('adminActionBtns');
  if(currentUser && currentUser.role === 'admin') adminBtns.classList.remove('hidden'); 
  else adminBtns.classList.add('hidden');
  
  document.getElementById('viewInvoiceModal').classList.remove('hidden');
}

function sendInvoiceWhatsApp() {
  const invNo = document.getElementById('viewInvNo').innerText; 
  const cust = document.getElementById('viewInvCust').innerText; 
  const total = document.getElementById('viewInvTotal').innerText;
  let msg = `*DECOR CONCEPT - Satış Qaiməsi*\nQaimə: ${invNo}\nMüştəri: ${cust}\n\n*Məhsullar:*\n`;
  transactionsList.filter(t => t.invoice === currentViewingInvoice).forEach(t => { if(t.type === "Satış") msg += `- ${t.product} (${t.qty} əd) = ${Number(t.total).toFixed(2)} ₼\n`; });
  msg += `\n*YEKUN ÖDƏNİŞ:* ${total}\n\nBizi seçdiyiniz üçün təşəkkürlər!`;
  window.open(`https://wa.me/?text=${encodeURIComponent(msg)}`, '_blank');
}

async function deleteCurrentInvoice() {
  if(!confirm("Bu qaimə ləğv ediləcək və məhsullar stoka qayıdacaq. Əminsiniz?")) return;
  await sendToGoogleSheets({ action: "DELETE_INVOICE", invoiceNo: currentViewingInvoice });
  closeInvoiceModal(); 
  setTimeout(() => loadDataFromSheets(), 1000);
}

function closeInvoiceModal() { 
  currentViewingInvoice = null; 
  document.getElementById('viewInvoiceModal').classList.add('hidden'); 
}

function renderReportsTable() {
  const tbody = document.getElementById('allTransactionsTableBody');
  if(!tbody) return;
  const grouped = []; const invMap = {};
  
  transactionsList.forEach(trx => {
    if (trx.type === "Satış" || trx.type === "Endirim") {
      if (!invMap[trx.invoice]) { 
        invMap[trx.invoice] = { date: trx.date, invoice: trx.invoice, type: "Satış", target: trx.target, total: 0 }; 
        grouped.push(invMap[trx.invoice]); 
      }
      invMap[trx.invoice].total += Number(trx.total);
    } else { grouped.push(trx); }
  });

  tbody.innerHTML = '';
  [...grouped].reverse().forEach(g => {
    let isSale = g.type === "Satış";
    let badge = isSale ? "text-emerald-600 bg-emerald-50" : (g.type.includes("Xərc")||g.type.includes("Qaytarılma")?"text-rose-600 bg-rose-50":"text-blue-600 bg-blue-50");
    let onClick = isSale ? `onclick="viewInvoiceDetails('${g.invoice}')" class="border-b hover:bg-slate-50 cursor-pointer"` : `class="border-b"`;
    tbody.innerHTML += `<tr ${onClick}><td class="p-3 text-slate-500">${g.date.split(',')[0]}</td><td class="p-3"><span class="px-2 py-0.5 rounded text-[10px] font-bold border ${badge}">${isSale ? g.invoice : g.type}</span></td><td class="p-3 font-bold truncate max-w-[120px]">${g.target}</td><td class="p-3 text-right font-bold">${Number(g.total).toFixed(2)} ₼</td></tr>`;
  });
}

function renderDashboardStats() {
  const tStr = getTodayStr(); 
  let sales = 0, expenses = 0, invMap = {};
  
  transactionsList.forEach(trx => {
    if(trx.date && trx.date.startsWith(tStr)) {
      if(trx.type === "Satış" || trx.type === "Endirim") {
        sales += Number(trx.total) || 0;
        if(trx.type === "Satış") {
          if(!invMap[trx.invoice]) invMap[trx.invoice] = { invoice: trx.invoice, target: trx.target, total: 0, time: trx.date.split(',')[1] || "" };
          invMap[trx.invoice].total += Number(trx.total);
        } else if(trx.type === "Endirim" && invMap[trx.invoice]) invMap[trx.invoice].total += Number(trx.total);
      } 
      else if(trx.type === "Xərc" || trx.type === "Qaytarılma") expenses += Math.abs(Number(trx.total)) || 0;
    }
  });
  
  const elSales = document.getElementById('dashSales');
  const elExp = document.getElementById('dashExpenses');
  const elBal = document.getElementById('dashBalance');
  
  if(elSales) elSales.innerText = sales.toFixed(2) + " ₼";
  if(elExp) elExp.innerText = expenses.toFixed(2) + " ₼";
  if(elBal) elBal.innerText = (sales - expenses).toFixed(2) + " ₼";

  const tbody = document.getElementById('todaySalesTableBody'); 
  if(!tbody) return;
  tbody.innerHTML = '';
  const todaysInvoices = Object.values(invMap);
  
  if(todaysInvoices.length === 0) { 
    tbody.innerHTML = `<tr><td colspan="3" class="p-4 text-center text-slate-400">Bugünkü satış yoxdur.</td></tr>`; 
    return; 
  }
  
  [...todaysInvoices].reverse().forEach(g => {
    tbody.innerHTML += `<tr onclick="viewInvoiceDetails('${g.invoice}')" class="border-b cursor-pointer hover:bg-slate-50"><td class="p-3 text-slate-500">${g.time.trim() || '-'}</td><td class="p-3"><p class="font-bold text-blue-600">${g.invoice}</p><p class="text-[10px] text-slate-500 truncate max-w-[120px]">${g.target}</p></td><td class="p-3 text-right font-bold text-emerald-600">${Number(g.total).toFixed(2)} ₼</td></tr>`;
  });
}

function dayEndReport() {
  renderDashboardStats();
  document.getElementById('deSales').innerText = document.getElementById('dashSales').innerText;
  document.getElementById('deExpenses').innerText = document.getElementById('dashExpenses').innerText;
  document.getElementById('deNet').innerText = document.getElementById('dashBalance').innerText;
  document.getElementById('dayEndModal').classList.remove('hidden');
}

function openStockModal() {
  const sel = document.getElementById('stockExistingSelect'); 
  sel.innerHTML = '';
  productsList.forEach(p => sel.innerHTML += `<option value="${p.name}">${p.name}</option>`);
  document.getElementById('stockModal').classList.remove('hidden');
}

function toggleStockType() {
  const type = document.getElementById('stockType').value;
  if(type === 'existing') { 
    document.getElementById('stockExistingDiv').classList.remove('hidden'); 
    document.getElementById('stockNewDiv').classList.add('hidden'); 
  } else { 
    document.getElementById('stockExistingDiv').classList.add('hidden'); 
    document.getElementById('stockNewDiv').classList.remove('hidden'); 
  }
}

async function processStockIn() {
  const type = document.getElementById('stockType').value;
  const qty = parseInt(document.getElementById('stockQty').value);
  const supplier = document.getElementById('stockSupplier').value.trim() || "-";
  let name = "", price = null;
  
  if(type === 'existing') { name = document.getElementById('stockExistingSelect').value; }
  else { 
    name = document.getElementById('stockNewName').value.trim(); 
    price = parseFloat(document.getElementById('stockNewPrice').value); 
    if(isNaN(price)) price = 0; 
  }
  
  if (!name || !qty || qty <= 0) return alert("Məlumatları düzgün daxil edin.");
  
  await sendToGoogleSheets({ action: "ADD_STOCK", date: parseCustomDate(new Date()), user: currentUser.name, supplier: supplier, items: [{ name: name, qty: qty, price: price }] });
  closeModal('stockModal'); 
  setTimeout(() => loadDataFromSheets(), 1500);
}

function populateReturnProducts() {
  const sel = document.getElementById('returnProduct'); 
  sel.innerHTML = '';
  productsList.forEach(p => sel.innerHTML += `<option value="${p.name}">${p.name}</option>`);
}

async function processReturn() {
  const prodName = document.getElementById('returnProduct').value;
  const qty = parseInt(document.getElementById('returnQty').value);
  const amount = parseFloat(document.getElementById('returnAmount').value);
  const custName = document.getElementById('returnCustomer').value.trim() || "Geri Qaytarılma";
  const payM = document.getElementById('returnPayMethod').value;
  
  if(!qty || qty <= 0 || isNaN(amount) || amount < 0) return alert("Düzgün say və məbləğ yazın.");
  
  await sendToGoogleSheets({ action: "RETURN_ITEM", date: parseCustomDate(new Date()), user: currentUser.name, customer: custName, product: prodName, qty: qty, amount: amount, paymentType: payM });
  closeModal('returnModal'); 
  setTimeout(() => loadDataFromSheets(), 1500);
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value.trim(); 
  const amount = parseFloat(document.getElementById('expAmount').value);
  if (!desc || isNaN(amount) || amount <= 0) return;
  await sendToGoogleSheets({ action: "ADD_EXPENSE", date: parseCustomDate(new Date()), user: currentUser.name, description: desc, amount: amount, paymentType: "Nağd" });
  closeModal('expenseModal'); 
  setTimeout(() => loadDataFromSheets(), 1500);
}

async function sendToGoogleSheets(payload) {
  showToast("Yazılır...", "blue");
  try { 
    await fetch(APPS_SCRIPT_URL, { method: "POST", mode: "no-cors", headers: { "Content-Type": "text/plain" }, body: JSON.stringify(payload) }); 
  } catch (err) {}
}

function showToast(msg, color="emerald") {
  const t = document.getElementById('toast'); 
  if(!t) return;
  document.getElementById('toast-msg').innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${color}-500`;
  t.classList.remove('-translate-y-20', 'opacity-0'); 
  setTimeout(() => t.classList.add('-translate-y-20', 'opacity-0'), 3000);
}

function closeModal(id) { 
  const el = document.getElementById(id);
  if(el) el.classList.add('hidden'); 
}
