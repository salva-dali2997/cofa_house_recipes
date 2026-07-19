# Cofa House Recipes

A minimal recipe box. Sign in to add recipes with ingredients and step-by-step
instructions; anyone can leave feedback on a recipe, with an optional name.

## Getting started

```
bin/setup
```

This installs gems and prepares the database. Then create your account:

```
bin/rails console
User.create!(email_address: "you@example.com", password: "...", password_confirmation: "...")
```

(or, non-interactively: `SEED_USER_EMAIL=you@example.com SEED_USER_PASSWORD=... bin/rails db:seed`)

Run the app with `bin/dev` and visit `http://localhost:3000`.

## Data model

- `User` — your account (`has_secure_password`); owns recipes.
- `Recipe` — name, instructions, belongs to a user.
- `Ingredient` — name + quantity, belongs to a recipe.
- `Feedback` — comment + optional name, belongs to a recipe. Anyone can create one.

## Deploying to Fly.io

One-time setup:

```
fly apps create cofa-house-recipes   # or edit the app name in fly.toml first
fly volumes create cofa_house_recipes_data --size 1 --region iad -a cofa-house-recipes
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key) -a cofa-house-recipes
```

Then add a `FLY_API_TOKEN` secret to the GitHub repo (Settings → Secrets and
variables → Actions) with the output of `fly tokens create deploy`. Every
push to `main` that passes CI (`.github/workflows/ci.yml`) will then deploy
automatically via `flyctl deploy --remote-only`.

You can also deploy by hand at any time with `fly deploy`.

Because recipes are stored in SQLite on a single Fly volume, keep the app to
one machine (`fly scale count 1`).

## What's in place

- Data model (5 tables, nothing extra): User (existing auth), Recipe (name, instructions, belongs to a user), Ingredient (name + quantity, belongs to a recipe), Feedback (comment + optional name, belongs to a recipe). Removed the ActiveStorage/ActionText tables and the Kamal deploy config that were in the original scaffold since they weren't needed here.
- Auth: recipes are public to view; creating/editing/deleting requires sign-in and ownership (you can't edit someone else's recipe). There's no public sign-up page — that's intentional for a personal app. Create your account with bin/rails console or the SEED_USER_EMAIL/SEED_USER_PASSWORD seed helper documented above.
- Feedback: anyone, signed in or not, can leave a comment + optional name on any recipe.
- UI: plain CSS (no framework), mobile-first, warm neutral palette (cream/terracotta), serif headings. Ingredients are added/removed dynamically via a small Stimulus controller (nested_form_controller.js) — a common Rails pattern worth studying.
- Fly.io: fly.toml (single machine, SQLite on a persistent volume) plus a deploy job appended to .github/workflows/ci.yml that runs flyctl deploy after all CI checks pass on pushes to main. One-time setup steps (fly apps create, fly volumes create, fly secrets set, and the FLY_API_TOKEN GitHub secret).

Worth knowing: if rebuilding the DB db:create/db:migrate can silently reuse the stale schema.rb instead of running the new migration files, which briefly resurrects the deleted ActiveStorage/ActionText tables. Deleting schema.rb before migrating will force it to run migrations fresh. Something to remember if there are ever restructure migrations done by hand again.