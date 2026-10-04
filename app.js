const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbyfrPCHC90rtnQ-bUJWVHSOeGU26DbhXRk1p4Y2pCdn0iWJ0lc0yXgnDGuLfW6ZJTn5/exec";
let currentUser = null; 
let cart = [];
let productsList = [
  { name: "Bambuk Panel Premium (290x12)", price: 28.50, stock: 110 },
  { name: "Mərmər Dekoru Panel (280x122)", price: 65.00, stock: 45 },
  { name: "Akustik Panel Slat (280x60)", price: 45.00, stock: 5 }
];
let offlineQueue = JSON.parse(localStorage.getItem('dc_offline_queue') || '[]');

function login() {
  const pin = document.getElementById('pinInput').value;
  if (pin === '3285') { currentUser = { name: 'Bəhram', role: 'admin' }; } 
  else if (pin === '2255') { currentUser = { name: 'Sadiq', role: 'staff' }; } 
  else { document.getElementById('loginError').classList.remove('hidden'); return; }
  
  document.getElementById('loginScreen').classList.add('hidden');
  document.getElementById('activeUser').innerText = currentUser.name;
  document.getElementById('mobileActiveUser').innerText = currentUser.name;
  document.getElementById('userInitial').innerText = currentUser.name.charAt(0);
  document.querySelectorAll('.cart-user-name').forEach(el => el.innerText = currentUser.name);
  
  if (currentUser.role === 'admin') {
    document.querySelectorAll('.admin-only').forEach(el => el.classList.remove('hidden'));
  }
  nav('dashboard');
  renderProducts();
  renderStockTable();
}

function logout() {
  currentUser = null;
  document.getElementById('pinInput').value = '';
  document.getElementById('loginScreen').classList.remove('hidden');
  document.querySelectorAll('.admin-only').forEach(el => el.classList.add('hidden'));
}

function nav(target) {
  document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
  document.getElementById('view-' + target).classList.remove('hidden');
  
  document.querySelectorAll('aside .nav-btn, nav .nav-btn').forEach(btn => {
    if (btn.dataset.target === target) {
      btn.classList.add('text-blue-600', 'bg-slate-800', 'text-white');
    } else {
      btn.classList.remove('text-blue-600', 'bg-slate-800', 'text-white');
    }
  });
}

function renderProducts(filter = "") {
  const grid = document.getElementById('posProductGrid');
  grid.innerHTML = '';
  productsList.filter(p => p.name.toLowerCase().includes(filter.toLowerCase())).forEach(p => {
    grid.innerHTML += `
      <div onclick="addToCart('${p.name}', ${p.price})" class="border rounded-lg p-3 hover:border-blue-500 cursor-pointer flex flex-col justify-between h-24 bg-white shadow-sm">
        <p class="text-xs font-semibold leading-tight line-clamp-2">${p.name}</p>
        <div class="flex justify-between items-end mt-2">
          <span class="text-[10px] text-slate-500 font-bold">Stok: ${p.stock}</span>
          <span class="text-sm font-bold text-blue-600">${p.price.toFixed(2)} ₼</span>
        </div>
      </div>
    `;
  });
}

function filterProducts() {
  renderProducts(document.getElementById('productSearch').value);
}

function renderStockTable() {
  const tbody = document.getElementById('stockTableBody');
  tbody.innerHTML = '';
  productsList.forEach(p => {
    tbody.innerHTML += `
      <tr class="border-b">
        <td class="p-3 font-medium">${p.name}</td>
        <td class="p-3 text-center font-bold text-blue-600">${p.stock}</td>
        <td class="p-3 text-right">${p.price.toFixed(2)} ₼</td>
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
  
  if (existing) { existing.qty++; } else { cart.push({ name, price, qty: 1 }); }
  renderCart();
}

function changeQty(index, delta) {
  const item = cart[index];
  const p = productsList.find(x => x.name === item.name);
  
  if (delta > 0 && item.qty + 1 > p.stock) {
    alert("Anbarda kifayət qədər məhsul yoxdur!");
    return;
  }
  
  item.qty += delta;
  if (item.qty <= 0) cart.splice(index, 1);
  renderCart();
}

function renderCart() {
  const cont = document.getElementById('cartItems');
  const empty = document.getElementById('emptyCart');
  if (cart.length === 0) {
    cont.innerHTML = ''; cont.appendChild(empty); empty.classList.remove('hidden');
    document.getElementById('cartTotal').innerText = '0.00 ₼';
    return;
  }
  empty.classList.add('hidden'); cont.innerHTML = '';
  let total = 0;
  cart.forEach((item, idx) => {
    total += item.qty * item.price;
    cont.innerHTML += `
      <div class="bg-white p-2 rounded border flex justify-between items-center shadow-sm">
        <div class="flex-1 pr-2"><p class="text-[11px] font-semibold text-slate-700">${item.name}</p><p class="text-[10px] text-blue-600 font-bold">${item.price.toFixed(2)} ₼</p></div>
        <div class="flex items-center gap-2 bg-slate-50 p-1 rounded border">
          <button onclick="changeQty(${idx}, -1)" class="w-6 h-6 bg-white shadow rounded">-</button>
          <span class="text-xs font-bold w-4 text-center">${item.qty}</span>
          <button onclick="changeQty(${idx}, 1)" class="w-6 h-6 bg-white shadow rounded">+</button>
        </div>
      </div>
    `;
  });
  document.getElementById('cartTotal').innerText = total.toFixed(2) + ' ₼';
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
    date: saleDate, user: currentUser.name, customer: custName,
    paymentType: payMethod, invoiceNo: invoiceNo, totalAmount: totalAmt,
    items: cart.map(i => ({ name: i.name, qty: i.qty, price: i.price, total: i.qty * i.price }))
  };

  document.getElementById('invCust').innerText = custName;
  document.getElementById('invUser').innerText = currentUser.name;
  document.getElementById('invTotal').innerText = totalAmt.toFixed(2) + ' ₼';
  
  const tbody = document.getElementById('invItemsTable');
  tbody.innerHTML = '';
  cart.forEach(item => {
    tbody.innerHTML += `<tr><td class="py-1">${item.name}</td><td class="text-center">${item.qty}</td><td class="text-right">${(item.price * item.qty).toFixed(2)}</td></tr>`;
  });

  await sendToGoogleSheets(payload);
  document.getElementById('invoiceModal').classList.remove('hidden');
  cart = []; document.getElementById('custName').value = '';
  renderCart(); renderProducts(); renderStockTable();
}

async function processStockIn() {
  const name = document.getElementById('stockProdName').value;
  const qty = parseInt(document.getElementById('stockQty').value);
  if (!name || !qty) return alert("Məlumatları doldurun!");

  let p = productsList.find(x => x.name.toLowerCase() === name.toLowerCase());
  if(p) { p.stock += qty; } 
  else { productsList.push({ name: name, price: 50.00, stock: qty }); }

  const payload = {
    action: "ADD_STOCK",
    date: new Date().toLocaleString('az-AZ'),
    user: currentUser.name, supplier: document.getElementById('stockSupplier').value,
    items: [{ name: name, qty: qty }]
  };

  await sendToGoogleSheets(payload);
  document.getElementById('stockProdName').value = '';
  document.getElementById('stockQty').value = '';
  renderProducts(); renderStockTable();
}

async function processExpense() {
  const desc = document.getElementById('expDesc').value.trim();
  const amount = parseFloat(document.getElementById('expAmount').value);
  
  if (!desc || isNaN(amount) || amount <= 0) {
    alert("Zəhmət olmasa düzgün təyinat və məbləğ daxil edin!");
    return;
  }

  const payload = {
    action: "ADD_EXPENSE",
    date: new Date().toLocaleString('az-AZ'),
    user: currentUser.name, 
    description: desc, 
    amount: amount,
    paymentType: document.getElementById('expMethod').value
  };

  closeModal('expenseModal');
  document.getElementById('expDesc').value = '';
  document.getElementById('expAmount').value = '';

  await sendToGoogleSheets(payload);
}

async function sendToGoogleSheets(payload) {
  if (!navigator.onLine) {
    offlineQueue.push(payload);
    localStorage.setItem('dc_offline_queue', JSON.stringify(offlineQueue));
    showToast("İnternet yoxdur! Yadda saxlanıldı.", "rose");
    return;
  }
  try {
    await fetch(APPS_SCRIPT_URL, { method: "POST", mode: "no-cors", headers: { "Content-Type": "text/plain" }, body: JSON.stringify(payload) });
    showToast("Bazaya uğurla yazıldı!", "emerald");
  } catch (err) {
    offlineQueue.push(payload);
    localStorage.setItem('dc_offline_queue', JSON.stringify(offlineQueue));
    showToast("Xəta! Yadda saxlanıldı.", "rose");
  }
}

function showToast(msg, color="emerald") {
  const t = document.getElementById('toast');
  document.getElementById('toast-msg').innerText = msg;
  t.className = `fixed top-5 right-5 z-[70] transform transition-all duration-300 pointer-events-none text-white px-4 py-3 rounded-xl shadow-2xl flex items-center gap-3 bg-${color}-500`;
  setTimeout(() => t.classList.add('-translate-y-20', 'opacity-0'), 3000);
}

function closeModal(id) { document.getElementById(id).classList.add('hidden'); }
function sendWhatsApp() {
  window.open(`https://wa.me/?text=DecorConcept%20Qaiməsi%20-%20Yekun:%20${document.getElementById('invTotal').innerText}`, '_blank');
}
function downloadExcel() {
  window.location.href = "DivarPanel_Stoklu_Baza.xlsx";
}
