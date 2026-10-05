import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
const cors={"Access-Control-Allow-Origin":"*","Access-Control-Allow-Headers":"authorization, x-client-info, apikey, content-type"};
const json=(x,status=200)=>new Response(JSON.stringify(x),{status,headers:{...cors,"Content-Type":"application/json"}});
const cryptoHex=async(s:string)=>{const b=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(s));return [...new Uint8Array(b)].map(x=>x.toString(16).padStart(2,"0")).join("")};
const db=createClient(Deno.env.get("SUPABASE_URL")!,Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

async function auth(token:string){
  if(!token) throw Error("Sessiya yoxdur");
  const h=await cryptoHex(token);
  const {data,error}=await db.from("user_sessions").select("id,user_id,expires_at,users(id,name,role,active)").eq("token_hash",h).maybeSingle();
  if(error||!data||new Date(data.expires_at)<=new Date()||(data.users as any)?.active!==true) throw Error("Sessiya etibarsızdır");
  return data.users as any;
}
function token(){const a=new Uint8Array(32);crypto.getRandomValues(a);return [...a].map(x=>x.toString(16).padStart(2,"0")).join("")}

Deno.serve(async(req)=>{
  if(req.method==="OPTIONS")return new Response("ok",{headers:cors});
  try{
    const body=await req.json(); const action=body.action;
    if(action==="login"){
      const pin=String(body.pin||"").trim(); if(!pin) throw Error("PIN daxil edin");
      const {data,error}=await db.from("users").select("id,name,role,pin_hash,active").eq("active",true);
      if(error)throw error;
      const u=data?.find((x:any)=>x.pin_hash && x.pin_hash && true);
      let found=null;
      for(const x of data||[]){const {data:ok}=await db.rpc("verify_pin",{p_hash:x.pin_hash,p_pin:pin}).maybeSingle().catch(()=>({data:false} as any));if(ok===true){found=x;break}}
      // Fallback direct SQL function below is preferred; verify_pin is created in schema extension section.
      if(!found) throw Error("PIN səhvdir");
      const raw=token(), hash=await cryptoHex(raw);
      await db.from("user_sessions").insert({user_id:found.id,token_hash:hash,expires_at:new Date(Date.now()+12*3600*1000).toISOString()});
      return json({token:raw,user:{id:found.id,name:found.name,role:found.role}});
    }
    const user=await auth(body.session_token);
    if(action==="bootstrap"){
      const [p,c,t]=await Promise.all([
        db.from("products").select("id,code,barcode,name,category,unit,purchase_price,sale_price,stock,min_stock").eq("active",true).order("name"),
        db.from("customers").select("id,code,name,phone,address,balance,total_purchase").order("name"),
        db.rpc("server_time_baku")
      ]);
      return json({products:p.data||[],customers:c.data||[],server_time:t.data});
    }
    if(action==="create_product"){
      if(user.role!=="admin")throw Error("Yalnız admin məhsul yarada bilər");
      const x=body; if(!x.code||!x.name)throw Error("Kod və ad tələb olunur");
      const {data,error}=await db.from("products").insert({code:x.code.trim(),name:x.name.trim(),barcode:x.barcode||null,purchase_price:Number(x.purchase_price||0),sale_price:Number(x.sale_price||0),min_stock:Number(x.min_stock||0)}).select().single();if(error)throw error;return json({product:data});
    }
    if(action==="create_customer"){
      const x=body;if(!x.code||!x.name)throw Error("Kod və ad tələb olunur");
      const {data,error}=await db.from("customers").insert({code:x.code.trim(),name:x.name.trim(),phone:x.phone||null,address:x.address||null}).select().single();if(error)throw error;return json({customer:data});
    }
    if(action==="stock_in"){
      const q=Number(body.qty),cost=Number(body.cost);if(q<=0||cost<0)throw Error("Miqdar/maya yanlışdır");
      const {data:p}=await db.from("products").select("id").eq("id",body.product_id).single();if(!p)throw Error("Məhsul tapılmadı");
      const {error:e1}=await db.rpc("stock_in_atomic",{p_user_id:user.id,p_product_id:body.product_id,p_qty:q,p_cost:cost});if(e1)throw e1;return json({ok:true});
    }
    if(action==="create_sale"){
      const {data,error}=await db.rpc("create_sale_atomic",{p_user_id:user.id,p_customer_id:body.customer_id||null,p_payment_type:body.payment_type,p_discount:Number(body.discount||0),p_items:body.items});
      if(error)throw error;return json(data);
    }
    if(action==="dashboard"){
      const {data,error}=await db.rpc("dashboard_today");if(error)throw error;return json(data);
    }
    if(action==="sales"){
      const {data,error}=await db.from("sales").select("invoice_no,created_at,total,payment_type,users(name),customers(name)").order("created_at",{ascending:false}).limit(300);if(error)throw error;
      return json({sales:(data||[]).map((x:any)=>({invoice_no:x.invoice_no,created_at:new Date(x.created_at).toLocaleString("az-AZ",{timeZone:"Asia/Baku"}),total:x.total,payment_type:x.payment_type,user_name:x.users?.name||"",customer_name:x.customers?.name||""}))});
    }
    throw Error("Naməlum əməliyyat");
  }catch(e:any){return json({error:e.message||String(e)},400)}
});