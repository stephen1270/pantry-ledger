alter table public.kv_store enable row level security;

create policy "Allow all access to kv_store"
on public.kv_store
for all
using (true)
with check (true);