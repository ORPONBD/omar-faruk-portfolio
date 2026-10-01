alter table public.site_content
  add column if not exists experience_summary text default '';

alter table public.projects
  add column if not exists services_used text default '',
  add column if not exists results text default '';
