create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  display_name text,
  role text not null default 'student',
  created_at timestamptz not null default now()
);

create table if not exists public.challenges (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references auth.users(id) on delete set null,
  owner_name text not null,
  invited_email text,
  payload jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.challenge_attempts (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references public.challenges(id) on delete cascade,
  player_id uuid references auth.users(id) on delete set null,
  player_name text not null,
  score integer not null,
  created_at timestamptz not null default now()
);

alter table public.challenges add column if not exists invited_email text;
alter table public.challenge_attempts add column if not exists player_id uuid references auth.users(id) on delete set null;

alter table public.profiles enable row level security;
alter table public.challenges enable row level security;
alter table public.challenge_attempts enable row level security;

drop policy if exists "Profiles are readable by everyone" on public.profiles;
create policy "Profiles are readable by everyone"
on public.profiles
for select
using (true);

drop policy if exists "Users can upsert their own profile" on public.profiles;
create policy "Users can upsert their own profile"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "Challenges are readable by everyone" on public.challenges;
create policy "Challenges are readable by everyone"
on public.challenges
for select
using (true);

drop policy if exists "Authenticated users can create challenges" on public.challenges;
create policy "Authenticated users can create challenges"
on public.challenges
for insert
to authenticated
with check (auth.uid() = owner_id);

drop policy if exists "Attempts are readable by everyone" on public.challenge_attempts;
create policy "Attempts are readable by everyone"
on public.challenge_attempts
for select
using (true);

drop policy if exists "Anyone can save attempts" on public.challenge_attempts;
create policy "Anyone can save attempts"
on public.challenge_attempts
for insert
to anon, authenticated
with check (true);
