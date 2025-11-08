-- migration: remove_rls_policies
-- description: removes all row-level security policies and disables rls on decks and flashcards tables.

-- step 1: drop rls policies for 'decks' table
drop policy if exists "allow authenticated users to select their own decks" on public.decks;
drop policy if exists "allow authenticated users to insert their own decks" on public.decks;
drop policy if exists "allow authenticated users to update their own decks" on public.decks;
drop policy if exists "allow authenticated users to delete their own decks" on public.decks;
drop policy if exists "disallow anonymous users to select decks" on public.decks;
drop policy if exists "disallow anonymous users to insert decks" on public.decks;
drop policy if exists "disallow anonymous users to update decks" on public.decks;
drop policy if exists "disallow anonymous users to delete decks" on public.decks;

-- step 2: drop rls policies for 'flashcards' table
drop policy if exists "allow authenticated users to select flashcards in their own decks" on public.flashcards;
drop policy if exists "allow authenticated users to insert flashcards into their own decks" on public.flashcards;
drop policy if exists "allow authenticated users to update flashcards in their own decks" on public.flashcards;
drop policy if exists "allow authenticated users to delete flashcards from their own decks" on public.flashcards;
drop policy if exists "disallow anonymous users to select flashcards" on public.flashcards;
drop policy if exists "disallow anonymous users to insert flashcards" on public.flashcards;
drop policy if exists "disallow anonymous users to update flashcards" on public.flashcards;
drop policy if exists "disallow anonymous users to delete flashcards" on public.flashcards;

-- step 3: disable row-level security (rls)
alter table public.decks disable row level security;
alter table public.flashcards disable row level security;
