create table if not exists public.contact_inquiries (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(btrim(name)) > 0),
  email text not null check (email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'),
  company text,
  service text not null check (length(btrim(service)) > 0),
  message text not null check (length(btrim(message)) > 0),
  status text not null default 'new' check (status in ('new', 'contacted', 'closed')),
  created_at timestamptz not null default now()
);

create index if not exists contact_inquiries_created_at_idx
  on public.contact_inquiries (created_at desc);
create index if not exists contact_inquiries_status_created_at_idx
  on public.contact_inquiries (status, created_at desc);

alter table public.contact_inquiries enable row level security;

revoke all on table public.contact_inquiries from public, anon, authenticated;
grant insert (name, email, company, service, message)
  on table public.contact_inquiries to anon, authenticated;
grant select, delete on table public.contact_inquiries to authenticated;
grant update (status) on table public.contact_inquiries to authenticated;

drop policy if exists "public insert contact inquiries" on public.contact_inquiries;
create policy "public insert contact inquiries"
  on public.contact_inquiries for insert to anon, authenticated
  with check (true);

drop policy if exists "authenticated read contact inquiries" on public.contact_inquiries;
create policy "authenticated read contact inquiries"
  on public.contact_inquiries for select to authenticated
  using (true);

drop policy if exists "authenticated update contact inquiry status" on public.contact_inquiries;
create policy "authenticated update contact inquiry status"
  on public.contact_inquiries for update to authenticated
  using (true)
  with check (status in ('new', 'contacted', 'closed'));

drop policy if exists "authenticated delete contact inquiries" on public.contact_inquiries;
create policy "authenticated delete contact inquiries"
  on public.contact_inquiries for delete to authenticated
  using (true);
