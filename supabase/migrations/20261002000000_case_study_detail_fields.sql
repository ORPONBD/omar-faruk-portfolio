alter table public.projects
  add column if not exists slug text,
  add column if not exists challenge text,
  add column if not exists strategy text,
  add column if not exists execution text,
  add column if not exists tools_used text;
