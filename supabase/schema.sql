create extension if not exists pgcrypto;

create table if not exists public.site_content (
  id integer primary key default 1 check (id = 1),
  hero_eyebrow text default 'DIGITAL MARKETING SPECIALIST · BANGLADESH',
  hero_title text default 'Turning attention into measurable growth.',
  hero_copy text default 'I help brands grow through performance marketing, Meta Ads, e-commerce strategy and data-driven optimization.',
  hero_primary_label text default 'Explore My Work',
  hero_primary_url text default '#work',
  hero_secondary_label text default 'Start a Conversation',
  hero_secondary_url text default '#contact',
  about_name text default 'Omar Faruk.',
  about_lead text default 'A Digital Marketing Specialist focused on helping brands grow through paid media, e-commerce marketing and performance-driven strategy.',
  about_body text default 'I work across Meta advertising, creative strategy, retargeting, analytics and conversion tracking. My goal is simple: understand the business, identify the bottleneck, test intelligently and scale what works.',
  experience_summary text default '',
  about_role text default 'Digital Marketing Specialist',
  about_specialties text default 'Meta Ads · Performance Marketing · E-commerce',
  profile_image_url text default '',
  contact_heading text default 'Have a growth challenge?',
  contact_copy text default 'Tell me what you are working on. Let’s see where performance marketing can make a difference.',
  email text default '',
  phone text default '',
  whatsapp_url text default '',
  linkedin_url text default '',
  facebook_url text default '',
  website_url text default '',
  seo_title text default 'Omar Faruk — Digital Marketing Specialist',
  seo_description text default 'Omar Faruk is a Digital Marketing Specialist focused on Meta Ads, performance marketing, e-commerce growth and conversion tracking.',
  footer_tagline text default 'Digital Marketing · Performance · Growth',
  updated_at timestamptz default now()
);

insert into public.site_content (id) values (1) on conflict (id) do nothing;

create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  sort_order integer default 0,
  number text default '01',
  title text not null,
  description text default '',
  cta_label text default 'Explore ↗',
  cta_url text default '#contact',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  sort_order integer default 0,
  category text default '',
  title text not null,
  description text default '',
  services_used text default '',
  results text default '',
  image_url text default '',
  cta_label text default 'View Work ↗',
  cta_url text default '#contact',
  featured boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.insights (
  id uuid primary key default gen_random_uuid(),
  sort_order integer default 0,
  category text default '',
  title text not null,
  excerpt text default '',
  url text default '#contact',
  published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.testimonials (
  id uuid primary key default gen_random_uuid(),
  sort_order integer default 0,
  name text not null,
  role text default '',
  company text default '',
  quote text not null,
  avatar_url text default '',
  published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.site_content add column if not exists experience_summary text default '';
alter table public.projects add column if not exists services_used text default '';
alter table public.projects add column if not exists results text default '';

alter table public.site_content enable row level security;
alter table public.services enable row level security;
alter table public.projects enable row level security;
alter table public.insights enable row level security;
alter table public.testimonials enable row level security;

-- Public visitors can read published portfolio content.
create policy "public read site content" on public.site_content for select using (true);
create policy "public read services" on public.services for select using (true);
create policy "public read projects" on public.projects for select using (true);
create policy "public read published insights" on public.insights for select using (published = true);
create policy "public read published testimonials" on public.testimonials for select using (published = true);

-- Authenticated admin can manage content. Public sign-up should remain disabled.
create policy "authenticated manage site content" on public.site_content for all to authenticated using (true) with check (true);
create policy "authenticated manage services" on public.services for all to authenticated using (true) with check (true);
create policy "authenticated manage projects" on public.projects for all to authenticated using (true) with check (true);
create policy "authenticated manage insights" on public.insights for all to authenticated using (true) with check (true);
create policy "authenticated manage testimonials" on public.testimonials for all to authenticated using (true) with check (true);

-- Seed current portfolio content.
insert into public.services (number,title,description,sort_order)
select * from (values
('01','Meta Ads','Campaign strategy, audience research, creative testing, retargeting and scalable account structures.',1),
('02','E-commerce Growth','Full-funnel acquisition strategies designed around product, offer, creative and conversion data.',2),
('03','Tracking & Analytics','GTM, GA4, Meta Pixel, Conversion API and event architecture for cleaner decision-making.',3),
('04','Creative Strategy','Scroll-stopping concepts, content angles and testing frameworks that turn creative into a performance lever.',4)
) v(number,title,description,sort_order)
where not exists (select 1 from public.services);

insert into public.projects (category,title,description,sort_order,featured)
select * from (values
('GADGETS / E-COMMERCE','Gearswheel','Building a performance-focused growth engine for an electronics brand.',1,true),
('CONSUMER TECH','Joyroom Bangladesh','Product-led campaigns built around creative testing and retargeting.',2,false),
('CONSUMER TECH','LDNIO Bangladesh','Premium product communication designed for social-first growth.',3,false),
('AUTOMOTIVE','Auto Space Engineering','Building a consistent digital presence for an automotive service brand.',4,false)
) v(category,title,description,sort_order,featured)
where not exists (select 1 from public.projects);

insert into public.insights (category,title,excerpt,sort_order)
select * from (values
('PAID MEDIA','How to structure a Meta Ads testing system','A practical framework for testing creative, audience and offer without wasting budget.',1),
('TRACKING','Why clean conversion tracking matters','How Pixel, GTM, GA4 and server-side signals work together to improve measurement.',2),
('E-COMMERCE','From product creative to profitable growth','The connection between product positioning, creative angles and campaign performance.',3)
) v(category,title,excerpt,sort_order)
where not exists (select 1 from public.insights);

-- Public image bucket for portfolio media.
insert into storage.buckets (id,name,public) values ('portfolio-media','portfolio-media',true) on conflict (id) do nothing;

create policy "public read portfolio media" on storage.objects for select using (bucket_id = 'portfolio-media');
create policy "authenticated upload portfolio media" on storage.objects for insert to authenticated with check (bucket_id = 'portfolio-media');
create policy "authenticated update portfolio media" on storage.objects for update to authenticated using (bucket_id = 'portfolio-media') with check (bucket_id = 'portfolio-media');
create policy "authenticated delete portfolio media" on storage.objects for delete to authenticated using (bucket_id = 'portfolio-media');
