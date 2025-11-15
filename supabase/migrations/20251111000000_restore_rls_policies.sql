-- migration: restore_rls_policies
-- description: restores all row-level security policies and enables rls on decks and flashcards tables.

-- step 1: enable row-level security (rls)
alter table public.decks enable row level security;
alter table public.flashcards enable row level security;

-- step 2: create rls policies for 'decks' table

-- policies for authenticated users
-- rationale: authenticated users should be able to fully manage their own decks.
create policy "allow authenticated users to select their own decks"
on public.decks for select
to authenticated
using (auth.uid() = user_id);

create policy "allow authenticated users to insert their own decks"
on public.decks for insert
to authenticated
with check (auth.uid() = user_id);

create policy "allow authenticated users to update their own decks"
on public.decks for update
to authenticated
using (auth.uid() = user_id);

create policy "allow authenticated users to delete their own decks"
on public.decks for delete
to authenticated
using (auth.uid() = user_id);

-- policies for anonymous users
-- rationale: anonymous users should not have any access to the decks table.
create policy "disallow anonymous users to select decks"
on public.decks for select
to anon
using (false);

create policy "disallow anonymous users to insert decks"
on public.decks for insert
to anon
with check (false);

create policy "disallow anonymous users to update decks"
on public.decks for update
to anon
using (false);

create policy "disallow anonymous users to delete decks"
on public.decks for delete
to anon
using (false);

-- step 3: create rls policies for 'flashcards' table

-- policies for authenticated users
-- rationale: authenticated users should be able to manage flashcards only within the decks they own.
create policy "allow authenticated users to select flashcards in their own decks"
on public.flashcards for select
to authenticated
using (exists (select 1 from public.decks where decks.id = flashcards.deck_id and decks.user_id = auth.uid()));

create policy "allow authenticated users to insert flashcards into their own decks"
on public.flashcards for insert
to authenticated
with check (exists (select 1 from public.decks where decks.id = flashcards.deck_id and decks.user_id = auth.uid()));

create policy "allow authenticated users to update flashcards in their own decks"
on public.flashcards for update
to authenticated
using (exists (select 1 from public.decks where decks.id = flashcards.deck_id and decks.user_id = auth.uid()));

create policy "allow authenticated users to delete flashcards from their own decks"
on public.flashcards for delete
to authenticated
using (exists (select 1 from public.decks where decks.id = flashcards.deck_id and decks.user_id = auth.uid()));

-- policies for anonymous users
-- rationale: anonymous users should not have any access to the flashcards table.
create policy "disallow anonymous users to select flashcards"
on public.flashcards for select
to anon
using (false);

create policy "disallow anonymous users to insert flashcards"
on public.flashcards for insert
to anon
with check (false);

create policy "disallow anonymous users to update flashcards"
on public.flashcards for update
to anon
using (false);

create policy "disallow anonymous users to delete flashcards"
on public.flashcards for delete
to anon
using (false);

