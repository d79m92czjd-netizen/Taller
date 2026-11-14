-- Pega esto en Supabase > SQL Editor y pulsa Run. Cambia los 2 correos.
create table clients(id uuid primary key default gen_random_uuid(),name text not null,contact text,phone text,email text,address text,notes text,created_at timestamptz default now());
create table quotes(id uuid primary key default gen_random_uuid(),number text,client_id uuid references clients on delete set null,title text,lines jsonb default '[]',iva numeric default 21,status text default 'borrador',notes text,created_at timestamptz default now());
create table expenses(id uuid primary key default gen_random_uuid(),date date default current_date,concept text,category text,amount numeric not null);
create table settings(key text primary key,value numeric);
do $$ declare t text; begin foreach t in array array['clients','quotes','expenses','settings'] loop
 execute format('alter table %I enable row level security',t);
 execute format($p$create policy only_owners on %I for all using (auth.jwt()->>'email' in ('jefe@tuempresa.com','jefa@tuempresa.com')) with check (auth.jwt()->>'email' in ('jefe@tuempresa.com','jefa@tuempresa.com'))$p$,t);
end loop; end $$;
