# Matrix Arena

This project is prepared for static deployment and can optionally connect to Supabase for accounts and saved challenges.

## Files

- `public/`: static site output directory for Cloudflare Pages
- `public/index.html`: the game
- `public/app-config.js`: frontend config for Supabase
- `public/_headers`: Cloudflare Pages response headers
- `wrangler.toml`: Cloudflare Pages configuration for CLI-based deploys
- `netlify.toml`: Netlify publish configuration
- `supabase-schema.sql`: database schema for accounts-backed challenge storage

## Cloudflare Pages: Dashboard Deploy

Use this if you want the simplest free deploy.

1. Create a Cloudflare account if you do not already have one.
2. Open `Workers & Pages`.
3. Select `Create application`.
4. Select `Pages`.
5. Choose one of these:
   - `Direct Upload` if you just want to upload the project quickly.
   - `Import an existing Git repository` if you want future updates to deploy automatically from GitHub.

If Cloudflare asks for build settings, use:

- Framework preset: `None`
- Build command: `exit 0`
- Build output directory: `public`

After deployment, Cloudflare will give you a free `*.pages.dev` URL to share with students.

## Direct Upload

If you use Direct Upload, upload the contents of the `public/` folder.

## Git-Based Deploy

If you want automatic deploys on every update:

1. Put this folder into a Git repository.
2. Push it to GitHub.
3. Import that repository into Cloudflare Pages.
4. Use the same build settings:
   - Framework preset: `None`
   - Build command: `exit 0`
   - Build output directory: `public`

## Why `public/`

The site is deployed from `public/` so that private local files, including project notes or instruction files, are not exposed on the public website.

## Supabase Setup

If you want real user registration, stored challenges, and saved challenge results:

1. Create a Supabase project.
2. Open the SQL editor and run `supabase-schema.sql`.
3. In `Authentication`, enable email/password sign-in.
4. Copy your project URL and anon key into `public/app-config.js`.
5. Redeploy the site.

After that, users can:

- create accounts
- sign in
- generate database-backed challenge links
- save challenge completion results
- receive direct challenges by email target
- see saved history and leaderboard data

Without Supabase configured, the site still works, but challenge links use encoded browser data instead of stored database records.

## Schema Update Note

If you already ran an older version of `supabase-schema.sql`, run the current file again.

The latest schema adds:

- `profiles` table for user metadata and instructor roles
- `invited_email` on `challenges`
- profile policies used by the new inbox/history/instructor features
