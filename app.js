// ==========================================
// SİZİN GOOGLE APPS SCRIPT URL-NİZ:
// ==========================================
const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbyTk9xPDcSElBwdQYUYWAPOy0hCKvKEXYr9cxAMq3iJ9Tygp2YTJrzqlvMf5wckwQohzg/exec";

let currentUser = null; 
let cart = [];
let offlineQueue = JSON.parse(localStorage.getItem('dc_offline_queue') || '[]');

// --- Authentication ---
function login() {
  const pin = document.getElementById('pinInput').value;
  if (pin === '3285') { 
    currentUser = { name: 'Bəhram', role: 'admin' }; 
  } else if (pin === '2255') { 
    currentUser = { name: 'Sadiq', role: 'staff' }; 
  } else {
    document.getElementById('loginError').classList.remove('hidden');
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
  updateOfflineUI();
}

function logout() {
  currentUser = null;
  document.getElementById('pinInput').value = '';
  document.getElementById('loginScreen').classList.remove('hidden');
  document.querySelectorAll('.admin-only').forEach(el => el.classList.add('hidden'));
}

// --- Navigation ---
function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  document.getElementById('view-' + target).classList.remove('hidden');
  
  // Update sidebar styling
  document.querySelectorAll('aside .nav-btn').forEach(btn => {
    if (btn.dataset.target === target) {
      btn.classList.add('text-white', 'bg-slate-800');
    } else {
      btn.classList.remove('text-white', 'bg-slate-800');
    }
  });

  // Update bottom nav styling
  document.querySelectorAll('nav .nav-btn').forEach(btn => {
    if (btn.dataset.target === target) {
      btn.classList.add('text-blue-600');
      btn.classList.remove('text-slate-400');
    } else {
      btn.classList.remove('text-blue-600');
      btn.classList.add('text-slate-400');
    }
  });
}

// --- POS Cart ---
function addToCart(name, price) {
  const existing = cart.find(i => i.name === name);
  if (existing) { existing.qty++; } else { cart.push({ name, price, qty: 1 }); }
  renderCart();
}

function changeQty(index, delta) {
  cart[index].qty += delta;
  if (cart[index].qty <= 0) cart.splice(index, 1);
  renderCart();
}

function renderCart() {
  const cont = document.getElementById('cartItems');
  const empty = document.getElementById('emptyCart');
  if (cart.length === 0) {
    cont.innerHTML = '';
    cont.appendChild(empty);
    empty.classList.remove('hidden');
    document.getElementById('cartTotal').innerText = '0.00 ₼';
    return;
  }
  empty.classList.add('hidden');
  cont.innerHTML = '';
  let total = 0;
  cart.forEach((item, idx) => {
    const itemTotal = item.qty * item.price;
    total += itemTotal;
    cont.innerHTML += `
      <div class="bg-white p-2 rounded border border-slate-100 flex justify-between items-center shadow-sm">
        <div class="flex-1 pr-2">
          <p class="text-[11px] font-semibold leading-tight text-slate-700">${item.name}</p>
          <p class="text-[10px] text-blue-600 font-bold mt-1">${item.price.toFixed(2)} ₼</p>
        </div>
        <div class="flex items-center gap-2 bg-slate-50 p-1 rounded-lg border shrink-0">
          <button onclick="changeQty(${idx}, -1)" class="w-6 h-6 bg-white shadow flex items-center justify-center rounded text-slate-600 hover:bg-slate-200">-</button>
          <span class="text-xs font-bold w-4 text-center">${item.qty}</span>
          <button onclick="changeQty(${idx}, 1)" class="w-6 h-6 bg-white shadow flex items-center justify-center rounded text-slate-600 hover:bg-slate-200">+</button>
        </div>
      </div>
    `;
  });
  document.getElementById('cartTotal').innerText = total.toFixed(2) + ' ₼';
}

// --- Process Operations (Sales, Stock, Expense) ---
async function processSale() {
  if (cart.length === 0) return alert("Səbət boşdur!");
  
  const btn = document.getElementById('btnSubmitSale');
  btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Göndərilir...';
  btn.disabled = true;

  const custName = document.getElementById('custName').value || 'Nağd Müştəri';
  const payMethod = document.getElementById('payMethod').value;
  const totalText = document.getElementById('cartTotal').innerText;
  const totalAmt = parseFloat(totalText);
  const invoiceNo = "INV-" + Date.now().toString().slice(-6);
  const saleDate = new Date().toLocaleString('az-AZ');

  const payload = {
    action: "ADD_SALE",
    date: saleDate,
    user: currentUser.name,
    customer: custName,
    paymentType: payMethod,
    invoiceNo: invoiceNo,
    totalAmount: totalAmt,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  document.getElementById('invDate').innerText = saleDate;
  document.getElementById('invCust').innerText = custName;
  document.getElementById('invUser').innerText = currentUser.name;
  document.getElementById('invNum').innerText = invoiceNo;
  document.getElementById('invTotal').innerText = totalText;
  
  const tbody = document.getElementById('invItemsTable');
  tbody.innerHTML = '';
  cart.forEach(item => {
    tbody.innerHTML += `<tr><td class="py-1">${item.name}</td><td class="text-center">${item.qty}</td><td class="text-right font-semibold">${(item.price * item.qty).toFixed(2)}</td></tr>`;
  });

  await sendToGoogleSheets(payload);

  document.getElementById('invoiceModal').classList.remove('hidden');
  cart = [];
  document.getElementById('custName').value = '';
  renderCart();
  
  btn.innerHTML = '<i class="fa-solid fa-check-double"></i> Satışı Təsdiqlə';
  btn.disabled = false;
}

async function processStockIn() {
  const name = document.getElementById('stockProdName').value;
  const qty = parseInt(document.getElementById('stockQty').value);
  const cost = parseFloat(document.getElementById('stockCost').value);
  const supplier = document.getElementById('stockSupplier').value;
  const payMethod = document.getElementById('stockPayMethod').value;

  if (!name || !qty || !cost) return alert("Məhsul adı, miqdar və maya dəyərini yazın!");

  const btn = document.getElementById('btnSubmitStock');
  btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Gözləyin...';
  btn.disabled = true;

  const payload = {
    action: "ADD_STOCK",
    date: new Date().toLocaleString('az-AZ'),
    user: currentUser.name,
    supplier: supplier,
    paymentType: payMethod,
    items: [{ name: name, qty: qty, cost: cost, total: qty * cost }]
  };

  await sendToGoogleSheets(payload);
  
  document.getElementById('stockProdName').value = '';
  document.getElementById('stockQty').value = '';
  document.getElementById('stockCost').value = '';

  btn.innerHTML = '<i class="fa-solid fa-plus"></i> Anbara Vur';
  btn.disabled = false;
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value;
  const amount = parseFloat(document.getElementById('expAmount').value);
  const method = document.getElementById('expMethod').value;
  
  if (!desc || !amount) return alert("Məlumatları tam doldurun!");

  const btn = document.getElementById('btnSubmitExpense');
  btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Göndərilir...';
  btn.disabled = true;

  const payload = {
    action: "ADD_EXPENSE",
    date: new Date().toLocaleString('az-AZ'),
    user: currentUser.name, 
    description: desc,
    amount: amount,
    paymentType: method
  };

  await sendToGoogleSheets(payload);
  closeModal('expenseModal');
  document.getElementById('expDesc').value = '';
  document.getElementById('expAmount').value = '';

  btn.innerHTML = '<i class="fa-solid fa-check"></i> Təsdiqlə və Çıx';
  btn.disabled = false;
}

// --- Google Sheets Integration & Offline Sync ---
async function sendToGoogleSheets(payload) {
  if (!navigator.onLine) {
    offlineQueue.push(payload);
    saveQueue();
    showToast("İnternet yoxdur! Yadda saxlanıldı.", "rose");
    return;
  }

  try {
    await fetch(APPS_SCRIPT_URL, {
      method: "POST",
      mode: "no-cors", 
      headers: { "Content-Type": "text/plain" },
      body: JSON.stringify(payload)
    });
    showToast("Uğurla bazaya yazıldı!", "emerald");
  } catch (err) {
    offlineQueue.push(payload);
    saveQueue();
    showToast("Xəta baş verdi. Yadda saxlanıldı.", "rose");
  }
}

function saveQueue() {
  localStorage.setItem('dc_offline_queue', JSON.stringify(offlineQueue));
  updateOfflineUI();
}

function updateOfflineUI() {
  const banner = document.getElementById('offlineBanner');
  if (!navigator.onLine || offlineQueue.length > 0) {
    banner.classList.remove('hidden');
    document.getElementById('queueCount').innerText = offlineQueue.length;
  } else {
    banner.classList.add('hidden');
  }
}

async function forceSync() {
  if (!navigator.onLine) return alert("İnternet bağlantısı yoxdur!");
  if (offlineQueue.length === 0) return showToast("Sinxronizasiya olundu. Gözləyən məlumat yoxdur.", "blue");
  
  showToast("Məlumatlar göndərilir...", "blue");
  let successCount = 0;
  const tempQueue = [...offlineQueue];
  offlineQueue = [];
  saveQueue();

  for (let p of tempQueue) {
    try {
      await fetch(APPS_SCRIPT_URL, { method: "POST", mode: "no-cors", headers: { "Content-Type": "text/plain" }, body: JSON.stringify(p) });
      successCount++;
    } catch(e) {
      offlineQueue.push(p);
    }
  }
  saveQueue();
  showToast(`${successCount} əməliyyat bazaya yazıldı!`, "emerald");
}

window.addEventListener('online', forceSync);
window.addEventListener('offline', updateOfflineUI);

// --- UI Helpers ---
function showToast(msg, colorStr="emerald") {
  const t = document.getElementById('toast');
  document.getElementById('toast-msg').innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${colorStr}-500 -translate-y-20 opacity-0`;
  
  // Force reflow
  void t.offsetWidth;
  t.classList.remove('-translate-y-20', 'opacity-0');
  
  setTimeout(() => {
    t.classList.add('-translate-y-20', 'opacity-0');
  }, 3000);
}

function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

function sendWhatsApp() {
  const custName = document.getElementById('invCust').innerText;
  const total = document.getElementById('invTotal').innerText;
  const num = document.getElementById('invNum').innerText;
  let text = `*DecorConcept (DivarPanel)*%0A_Eurohome Filialı_%0AƏlaqə: 055 203 22 71%0A%0AQaimə: ${num}%0AMüştəri: ${custName}%0Aİcra edən: ${currentUser.name}%0A%0A*Məhsullar:*%0A`;
  
  document.querySelectorAll('#invItemsTable tr').forEach(tr => {
    const tds = tr.querySelectorAll('td');
    text += `- ${tds[0].innerText} (x${tds[1].innerText}) = ${tds[2].innerText} ₼%0A`;
  });
  text += `%0A*YEKUN:* ${total}`;
  window.open(`https://wa.me/?text=${text}`, '_blank');
}

function downloadExcel() {
  const ws_trx = XLSX.utils.json_to_sheet([{Tarix:"Misal",Tip:"Satış",Təyinat:"Nümunə cədvəl",Məbləğ:100}]);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws_trx, "Əməliyyatlar");
  XLSX.utils.book_append_sheet(wb, ws_trx, "Məhsullar");
  XLSX.utils.book_append_sheet(wb, ws_trx, "Müştərilər");
  XLSX.utils.book_append_sheet(wb, ws_trx, "Kassa");
  XLSX.writeFile(wb, "DivarPanel_Baza.xlsx");
}