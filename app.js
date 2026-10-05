const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbzz8k3fNEg5LdmgaCDcY1_ssUzHQh2ZQExWWA2mf0qf94r9Ewu9mDxdMG68cNN5aTI2nA/exec";

let currentUser = null; let cart = []; let productsList = []; let transactionsList = []; let tempProduct = null;
let currentViewingInvoice = null; 
let editingInvoiceNo = null; // Redaktə rejimində olan qaimə nömrəsi

document.addEventListener("DOMContentLoaded", () => { loadDataFromSheets(); });

function getTodayStr() {
  const d = new Date(); return `${d.getDate().toString().padStart(2,'0')}.${(d.getMonth()+1).toString().padStart(2,'0')}.${d.getFullYear()}`;
}

async function loadDataFromSheets() {
  showToast("Yüklənir...", "blue");
  try {
    const response = await fetch(APPS_SCRIPT_URL, { method: "GET", redirect: "follow" });
    const textData = await response.text();
    let data = JSON.parse(textData);

    if(data.status === "success") {
      productsList = data.products || [];
      transactionsList = (data.transactions || []).map(t => {
        if(t.date && t.date.includes("T")) {
           let d = new Date(t.date); if(!isNaN(d)) t.date = d.toLocaleString('az-AZ');
        }
        return t;
      });
      renderProducts(); renderStockTable(); renderReportsTable(); renderDashboardStats();
      showToast("Sinxronlaşdırıldı!", "emerald");
    }
  } catch(err) { showToast("Bağlantı xətası.", "rose"); }
}

function login() {
  const pin = document.getElementById('pinInput').value.trim();
  if (pin === '3285') { currentUser = { name: 'Bəhram', role: 'admin' }; } 
  else if (pin === '2255') { currentUser = { name: 'Sadiq', role: 'staff' }; } 
  else { document.getElementById('loginError').classList.remove('hidden'); return; }
  
  document.getElementById('loginScreen').classList.add('hidden');
  document.getElementById('activeUser').innerText = currentUser.name;
  document.getElementById('mobileActiveUser').innerText = currentUser.name;
  nav('dashboard'); loadDataFromSheets();
}

function logout() { currentUser = null; document.getElementById('pinInput').value = ''; document.getElementById('loginScreen').classList.remove('hidden'); }
function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  document.getElementById('view-' + target).classList.remove('hidden');
  document.querySelectorAll('.nav-btn').forEach(btn => { btn.classList.toggle('text-blue-600', btn.dataset.target === target); });
}

function renderProducts(filter = "") {
  const grid = document.getElementById('posProductGrid'); if(!grid) return; grid.innerHTML = '';
  productsList.filter(p => p.name.toLowerCase().includes(filter.toLowerCase())).forEach(p => {
    grid.innerHTML += `<div onclick="addToCart('${p.name}', ${p.price})" class="border rounded-lg p-2 hover:border-blue-500 cursor-pointer flex flex-col justify-between bg-white h-20 shadow-sm"><p class="text-[11px] font-bold leading-tight">${p.name}</p><div class="flex justify-between items-end mt-1"><span class="text-[10px] text-slate-500">Stok: ${p.stock}</span><span class="text-xs font-bold text-blue-600">${Number(p.price).toFixed(2)} ₼</span></div></div>`;
  });
}
function filterProducts() { renderProducts(document.getElementById('productSearch').value); }
function renderStockTable() {
  const tbody = document.getElementById('stockTableBody'); tbody.innerHTML = '';
  productsList.forEach(p => { tbody.innerHTML += `<tr class="border-b"><td class="p-2">${p.name}</td><td class="p-2 font-bold text-center">${p.stock}</td><td class="p-2 text-right">${Number(p.price).toFixed(2)} ₼</td></tr>`; });
}

function addToCart(name, price) {
  tempProduct = productsList.find(x => x.name === name);
  document.getElementById('addProdName').innerText = tempProduct.name;
  document.getElementById('addProdMaxStock').innerText = tempProduct.stock;
  document.getElementById('addProdQty').value = 1; document.getElementById('addProdPrice').value = price;
  document.getElementById('addProductModal').classList.remove('hidden');
}

function confirmAddToCart() {
  if (!tempProduct) return;
  const qty = parseFloat(document.getElementById('addProdQty').value); const price = parseFloat(document.getElementById('addProdPrice').value);
  if (isNaN(qty) || qty <= 0 || isNaN(price) || price < 0) return alert("Düzgün yazın!");
  
  const existing = cart.find(i => i.name === tempProduct.name);
  // Redaktə vaxtı eyni məhsulun öz köhnə stokunu nəzərə almalıyıq ki, limitə düşməsin, amma indilik sadə yoxlama.
  if (!editingInvoiceNo && (existing ? existing.qty : 0) + qty > tempProduct.stock) return alert("Anbarda yoxdur!");
  if (existing) { existing.qty += qty; existing.price = price; } else { cart.push({ name: tempProduct.name, price: price, qty: qty }); }
  
  closeModal('addProductModal'); renderCart();
}

function changeQty(index, delta) {
  const item = cart[index]; const p = productsList.find(x => x.name === item.name);
  if (!editingInvoiceNo && delta > 0 && item.qty + delta > p.stock) return alert("Kifayət qədər stok yoxdur!");
  item.qty += delta; if (item.qty <= 0) cart.splice(index, 1); renderCart();
}

function renderCart() {
  const cont = document.getElementById('cartItems');
  if (cart.length === 0) {
    cont.innerHTML = '<div class="text-center py-8 text-slate-400 text-xs">Səbət boşdur</div>'; 
    document.getElementById('cartTotal').innerText = '0.00 ₼'; return;
  }
  cont.innerHTML = ''; let subTotal = 0;
  cart.forEach((item, idx) => {
    subTotal += item.qty * item.price;
    cont.innerHTML += `<div class="bg-white p-2 border rounded mb-1.5"><div class="flex justify-between"><p class="text-[11px] font-bold truncate max-w-[150px]">${item.name}</p><button onclick="changeQty(${idx}, -item.qty)" class="text-rose-500 text-xs px-1">✕</button></div><div class="flex justify-between items-center mt-1.5"><span class="text-[11px] text-blue-600 font-bold">${item.price.toFixed(2)} ₼</span><div class="flex gap-2 bg-slate-50 border rounded px-1"><button onclick="changeQty(${idx}, -1)" class="px-2">-</button><span class="text-xs font-bold pt-0.5">${item.qty}</span><button onclick="changeQty(${idx}, 1)" class="px-2">+</button></div></div></div>`;
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
  const saleDate = new Date().toLocaleString('az-AZ');

  const payload = {
    action: isEditing ? "EDIT_SALE" : "ADD_SALE", 
    date: saleDate, user: currentUser.name, customer: finalCust, paymentType: payM,
    invoiceNo: invoiceNo, totalAmount: totalAmt, discount: discountVal,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  sendToGoogleSheets(payload); // await etmirik sürətli olsun

  // Uİ Təmizləmə və Vəziyyəti Qaytarma
  cancelEdit(true); // Cart təmizlənir, düymə qaytarılır
  setTimeout(() => loadDataFromSheets(), 1000); // 1 saniyə sonra məlumatları yenilə
  
  // Əgər yeni satışdırsa, Qaiməni dərhal ekrana çıxarırıq (lokal array-ə atıb)
  if(!isEditing) {
    cart.forEach(i => { transactionsList.push({ date: saleDate, type: "Satış", user: currentUser.name, target: finalCust, product: i.name, qty: i.qty, price: i.price, total: i.qty * i.price, payment: payM, invoice: invoiceNo }); });
    if(discountVal > 0) transactionsList.push({ date: saleDate, type: "Endirim", user: currentUser.name, target: finalCust, product: "Satış Endirimi", qty: 1, price: -discountVal, total: -discountVal, payment: payM, invoice: invoiceNo });
    viewInvoiceDetails(invoiceNo);
  }
}

// === ADMİN: QAİMƏNİ REDAKTƏ ETMƏK ===
function editInvoice() {
  if (!currentViewingInvoice) return;
  const group = transactionsList.filter(t => t.invoice === currentViewingInvoice);
  if(group.length === 0) return;
  
  editingInvoiceNo = currentViewingInvoice;
  cart = []; let discount = 0;
  let customerStr = group[0].target; 
  let payM = group[0].payment;
  
  group.forEach(t => {
    if (t.type === "Satış") cart.push({ name: t.product, price: Number(t.price), qty: Number(t.qty) });
    else if (t.type === "Endirim") discount = Math.abs(Number(t.total));
  });
  
  let custName = customerStr; let custPhone = "";
  if (customerStr.includes(" - ")) {
    let parts = customerStr.split(" - ");
    custName = parts[0]; custPhone = parts[1];
  }
  
  document.getElementById('custName').value = custName;
  document.getElementById('custPhone').value = custPhone;
  document.getElementById('saleDiscount').value = discount > 0 ? discount : '';
  document.getElementById('payMethod').value = payM;
  
  const btn = document.getElementById('processSaleBtn');
  btn.innerText = "Dəyişikliyi Yadda Saxla";
  btn.classList.replace('bg-emerald-600', 'bg-blue-600');
  btn.classList.replace('hover:bg-emerald-700', 'hover:bg-blue-700');
  document.getElementById('cancelEditBtn').classList.remove('hidden');
  
  closeInvoiceModal(); nav('pos'); renderCart();
}

function cancelEdit(isAfterSale = false) {
  editingInvoiceNo = null;
  cart = []; 
  document.getElementById('custName').value = ''; 
  document.getElementById('custPhone').value = ''; 
  document.getElementById('saleDiscount').value = '';
  
  const btn = document.getElementById('processSaleBtn');
  btn.innerText = "Qaimə Yarat & Təsdiqlə";
  btn.classList.replace('bg-blue-600', 'bg-emerald-600');
  btn.classList.replace('hover:bg-blue-700', 'hover:bg-emerald-700');
  document.getElementById('cancelEditBtn').classList.add('hidden');
  
  renderCart();
}

function viewInvoiceDetails(invNo) {
  const group = transactionsList.filter(t => t.invoice === invNo);
  if(group.length === 0) return;
  
  currentViewingInvoice = invNo;
  let subTotal = 0, discount = 0, itemsHtml = '';
  
  group.forEach(t => {
      if(t.type === "Endirim") discount = Math.abs(Number(t.total));
      else if (t.type === "Satış") {
          subTotal += Number(t.total);
          itemsHtml += `<tr><td class="py-1 border-b">${t.product}</td><td class="text-center border-b">${t.qty}</td><td class="text-right font-bold border-b">${Number(t.total).toFixed(2)}</td></tr>`;
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
  
  let msg = `*DECOR CONCEPT - Satış Qaiməsi*\n`;
  msg += `Qaimə: ${invNo}\nMüştəri: ${cust}\n\n*Məhsullar:*\n`;
  
  const group = transactionsList.filter(t => t.invoice === currentViewingInvoice);
  group.forEach(t => { if(t.type === "Satış") msg += `- ${t.product} (${t.qty} əd) = ${Number(t.total).toFixed(2)} ₼\n`; });
  
  msg += `\n*YEKUN ÖDƏNİŞ:* ${total}\n\nBizi seçdiyiniz üçün təşəkkürlər!`;
  window.open(`https://wa.me/?text=${encodeURIComponent(msg)}`, '_blank');
}

async function deleteCurrentInvoice() {
  if(!confirm("Bu qaimə tamamilə ləğv ediləcək və məhsullar stoka qayıdacaq. Əminsiniz?")) return;
  const payload = { action: "DELETE_INVOICE", invoiceNo: currentViewingInvoice };
  await sendToGoogleSheets(payload);
  closeInvoiceModal(); setTimeout(() => loadDataFromSheets(), 1000);
}

function closeInvoiceModal() { currentViewingInvoice = null; document.getElementById('viewInvoiceModal').classList.add('hidden'); }

function renderReportsTable() {
  const tbody = document.getElementById('allTransactionsTableBody');
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
    let badge = isSale ? "text-emerald-600 bg-emerald-50" : (g.type==="Xərc"?"text-rose-600 bg-rose-50":"text-blue-600 bg-blue-50");
    let onClick = isSale ? `onclick="viewInvoiceDetails('${g.invoice}')" class="border-b hover:bg-slate-50 cursor-pointer"` : `class="border-b"`;
    tbody.innerHTML += `<tr ${onClick}><td class="p-2.5 text-slate-500">${g.date.split(' ')[0] || g.date.split(',')[0]}</td><td class="p-2.5"><span class="px-1.5 py-0.5 rounded text-[10px] font-bold border ${badge}">${isSale ? g.invoice : g.type}</span></td><td class="p-2.5 font-bold truncate max-w-[100px]">${g.target}</td><td class="p-2.5 text-right font-bold">${Number(g.total).toFixed(2)} ₼</td></tr>`;
  });
}

function renderDashboardStats() {
  const tStr = getTodayStr(); let sales = 0, expenses = 0, invMap = {};
  
  transactionsList.forEach(trx => {
    if(trx.date && trx.date.includes(tStr)) {
      if(trx.type === "Satış" || trx.type === "Endirim") {
        sales += Number(trx.total) || 0;
        if(trx.type === "Satış") {
          if(!invMap[trx.invoice]) invMap[trx.invoice] = { invoice: trx.invoice, target: trx.target, total: 0, time: trx.date.split(' ')[1] || trx.date.split(',')[1] };
          invMap[trx.invoice].total += Number(trx.total);
        } else if(trx.type === "Endirim" && invMap[trx.invoice]) invMap[trx.invoice].total += Number(trx.total);
      } 
      else if(trx.type === "Xərc") expenses += Number(trx.total) || 0;
    }
  });
  
  document.getElementById('dashSales').innerText = sales.toFixed(2) + " ₼";
  document.getElementById('dashExpenses').innerText = expenses.toFixed(2) + " ₼";
  document.getElementById('dashBalance').innerText = (sales - expenses).toFixed(2) + " ₼";

  const tbody = document.getElementById('todaySalesTableBody'); tbody.innerHTML = '';
  const todaysInvoices = Object.values(invMap);
  if(todaysInvoices.length === 0) { tbody.innerHTML = `<tr><td colspan="3" class="p-4 text-center text-slate-400">Bugünkü satış yoxdur.</td></tr>`; return; }
  
  [...todaysInvoices].reverse().forEach(g => {
    tbody.innerHTML += `<tr onclick="viewInvoiceDetails('${g.invoice}')" class="border-b cursor-pointer hover:bg-slate-50"><td class="p-2.5 text-slate-500">${g.time || '-'}</td><td class="p-2.5"><p class="font-bold text-blue-600">${g.invoice}</p><p class="text-[10px] text-slate-500 truncate max-w-[120px]">${g.target}</p></td><td class="p-2.5 text-right font-bold text-emerald-600">${Number(g.total).toFixed(2)} ₼</td></tr>`;
  });
}

function dayEndReport() {
  renderDashboardStats();
  document.getElementById('deSales').innerText = document.getElementById('dashSales').innerText;
  document.getElementById('deExpenses').innerText = document.getElementById('dashExpenses').innerText;
  document.getElementById('deNet').innerText = document.getElementById('dashBalance').innerText;
  document.getElementById('dayEndModal').classList.remove('hidden');
}

async function processStockIn() {
  const name = document.getElementById('stockProdName').value.trim(); const qty = parseInt(document.getElementById('stockQty').value);
  if (!name || !qty) return;
  await sendToGoogleSheets({ action: "ADD_STOCK", date: new Date().toLocaleString('az-AZ'), user: currentUser.name, supplier: "-", items: [{ name: name, qty: qty }] });
  closeModal('stockModal'); loadDataFromSheets();
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value.trim(); const amount = parseFloat(document.getElementById('expAmount').value);
  if (!desc || isNaN(amount) || amount <= 0) return;
  await sendToGoogleSheets({ action: "ADD_EXPENSE", date: new Date().toLocaleString('az-AZ'), user: currentUser.name, description: desc, amount: amount, paymentType: "Nağd" });
  closeModal('expenseModal'); loadDataFromSheets();
}

async function sendToGoogleSheets(payload) {
  showToast("Yazılır...", "blue");
  try { await fetch(APPS_SCRIPT_URL, { method: "POST", mode: "no-cors", headers: { "Content-Type": "text/plain" }, body: JSON.stringify(payload) }); } catch (err) {}
}
function showToast(msg, color="emerald") {
  const t = document.getElementById('toast'); document.getElementById('toast-msg').innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${color}-500`;
  t.classList.remove('-translate-y-20', 'opacity-0'); setTimeout(() => t.classList.add('-translate-y-20', 'opacity-0'), 3000);
}
function closeModal(id) { document.getElementById(id).classList.add('hidden'); }
