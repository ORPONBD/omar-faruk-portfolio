# Omar Faruk Portfolio + Admin CMS

Netlify-ready portfolio with a Supabase-powered admin dashboard.

## Before deploying
1. Open `site-config.js` and `admin/config.js`.
2. Set `SUPABASE_URL` to your Supabase project URL (for example `https://YOUR-PROJECT.supabase.co`).
3. Set `SUPABASE_ANON_KEY` to the **Publishable key** from Supabase Settings → API Keys. Never use a secret/service-role key in browser code.
4. The database schema is in `supabase/schema.sql`; run it once in Supabase SQL Editor.
5. Create your admin user in Supabase Authentication → Users.

## Deploy
- Push the folder contents to your GitHub repository root.
- Netlify: import the GitHub repo.
- Branch: `main`
- Build command: blank
- Base directory: blank
- Publish directory: `.`

## Admin
After deploy, open `/admin/` and sign in with your Supabase user.

The admin can edit homepage/about/contact/SEO settings and CRUD services, projects, insights, and testimonials. Image fields support direct URL entry and authenticated upload to the `portfolio-media` Supabase Storage bucket.
