create table if not exists public.trusted_brands (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  logo_url text not null,
  website_url text,
  display_order integer not null default 0,
  is_active boolean not null default true,
  grayscale boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.trusted_brands enable row level security;

drop policy if exists "public read active trusted brands" on public.trusted_brands;
create policy "public read active trusted brands"
  on public.trusted_brands for select
  using (is_active = true);

drop policy if exists "authenticated manage trusted brands" on public.trusted_brands;
create policy "authenticated manage trusted brands"
  on public.trusted_brands for all to authenticated
  using (true) with check (true);

grant select on public.trusted_brands to anon, authenticated;
grant all on public.trusted_brands to authenticated;
