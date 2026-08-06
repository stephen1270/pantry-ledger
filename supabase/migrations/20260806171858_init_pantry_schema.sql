create table if not exists public.products (
  id text primary key,
  date_added date not null default current_date,
  name text not null,
  brand text,
  category text,
  source text,
  price numeric,
  tags text[] default '{}',
  notes text,
  overall smallint check (overall between 1 and 10),
  flavor smallint check (flavor between 1 and 10),
  quality smallint check (quality between 1 and 10),
  value smallint check (value between 1 and 10),
  photo_paths text[] default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- keep updated_at fresh on edits
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_products_updated_at
before update on public.products
for each row execute function public.set_updated_at();

-- Supabase requires RLS to be explicitly configured
alter table public.products enable row level security;

-- single-user app: allow full access via the anon key
create policy "Allow all access to products"
on public.products
for all
using (true)
with check (true);