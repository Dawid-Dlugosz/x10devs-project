# 🗄️ Database Migration Guide

Ten dokument opisuje jak wykonać migrację bazy danych z lokalnej instancji Supabase do zdalnej (testowej lub produkcyjnej).

> **💡 Szybki start?** Jeśli dopiero zaczynasz z projektem, zobacz [QUICKSTART.md](QUICKSTART.md) dla uproszczonej instrukcji.

## 📋 Spis treści

1. [Metoda 1: Supabase CLI (Rekomendowana)](#metoda-1-supabase-cli-rekomendowana)
2. [Metoda 2: Skrypty Shell](#metoda-2-skrypty-shell)
3. [Metoda 3: Ręczne wykonanie w Dashboard](#metoda-3-ręczne-wykonanie-w-dashboard)
4. [Weryfikacja migracji](#weryfikacja-migracji)
5. [Rollback](#rollback)

---

## Metoda 1: Supabase CLI (Rekomendowana)

### Krok 1: Połącz projekt z zdalną bazą

```bash
supabase link --project-ref iapmykfcsntlqfxqwcoh
```

**Project Reference ID:** `iapmykfcsntlqfxqwcoh`

Możesz też znaleźć swój project-ref w:
- URL: `https://app.supabase.com/project/iapmykfcsntlqfxqwcoh`
- Dashboard → Settings → General → Reference ID

### Krok 2: Zastosuj migracje

```bash
supabase db push
```

To polecenie automatycznie:
- Wykryje wszystkie migracje w `supabase/migrations/`
- Zastosuje je w odpowiedniej kolejności
- Utworzy tabelę `supabase_migrations.schema_migrations` do śledzenia statusu

### Dodatkowe polecenia

```bash
# Sprawdź różnice między lokalną a zdalną bazą
supabase db diff

# Zresetuj zdalną bazę (UWAGA: usuwa wszystkie dane!)
supabase db reset --linked

# Sprawdź status połączenia
supabase status
```

---

## Metoda 2: Skrypty Shell

### Przygotowanie

1. Upewnij się, że plik `.env.test` zawiera:

```env
SUPABASE_URL=https://iapmykfcsntlqfxqwcoh.supabase.co
SUPABASE_ANON_KEY=twoj-anon-key
SUPABASE_DATABASE_URL=postgresql://postgres:[PASSWORD]@db.iapmykfcsntlqfxqwcoh.supabase.co:5432/postgres
```

**Gdzie znaleźć dane:**
- **SUPABASE_ANON_KEY:** Dashboard → Settings → API → Project API keys → anon public
- **SUPABASE_DATABASE_URL:** Dashboard → Project Settings → Database → Connection string → URI
- **WAŻNE:** Zastąp `[PASSWORD]` swoim hasłem do bazy danych

### Wykonanie migracji

```bash
./migrate_from_env.sh
```

Ten skrypt:
1. Wczytuje konfigurację z `.env.test`
2. Weryfikuje wymagane zmienne
3. Wykonuje wszystkie migracje w kolejności

### Ręczne wykonanie (jeśli masz już DATABASE_URL)

```bash
export DATABASE_URL='postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/postgres'
./migrate.sh
```

---

## Metoda 3: Ręczne wykonanie w Dashboard

### Krok po kroku:

1. **Zaloguj się do Supabase Dashboard**
   - Przejdź do: https://app.supabase.com

2. **Otwórz SQL Editor**
   - W menu wybierz: `SQL Editor`

3. **Wykonaj migracje w kolejności:**

   **3.1. Pierwsza migracja (Initial Schema)**
   ```
   Otwórz: supabase/migrations/20251102214545_initial_schema_decks_flashcards.sql
   Skopiuj całą zawartość i wykonaj w SQL Editor
   ```

   **3.2. Druga migracja (Remove RLS)**
   ```
   Otwórz: supabase/migrations/20251105200000_remove_rls_policies.sql
   Skopiuj całą zawartość i wykonaj w SQL Editor
   ```

   **3.3. Trzecia migracja (Restore RLS)**
   ```
   Otwórz: supabase/migrations/20251111000000_restore_rls_policies.sql
   Skopiuj całą zawartość i wykonaj w SQL Editor
   ```

4. **Sprawdź rezultaty**
   - Przejdź do: `Table Editor`
   - Zweryfikuj czy tabele `decks` i `flashcards` zostały utworzone

---

## Weryfikacja migracji

### Sprawdź strukturę tabel

```sql
-- Lista wszystkich tabel
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Sprawdź kolumny tabeli decks
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'decks';

-- Sprawdź kolumny tabeli flashcards
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'flashcards';
```

### Sprawdź RLS policies

```sql
-- Sprawdź policies dla tabeli decks
SELECT policyname, cmd, qual 
FROM pg_policies 
WHERE tablename = 'decks';

-- Sprawdź policies dla tabeli flashcards
SELECT policyname, cmd, qual 
FROM pg_policies 
WHERE tablename = 'flashcards';
```

### Sprawdź triggery

```sql
-- Lista triggerów
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers
WHERE event_object_schema = 'public';
```

---

## Rollback

### Supabase CLI

Jeśli używasz Supabase CLI, możesz cofnąć migracje:

```bash
# Cofnij ostatnią migrację
supabase migration repair --status reverted <migration-version>

# Następnie zresetuj bazę do poprzedniego stanu
supabase db reset
```

### Ręczny rollback

Jeśli potrzebujesz ręcznie cofnąć zmiany, wykonaj następujące SQL:

```sql
-- Usuń triggery
DROP TRIGGER IF EXISTS on_flashcard_insert ON public.flashcards;
DROP TRIGGER IF EXISTS on_flashcard_delete ON public.flashcards;

-- Usuń funkcję
DROP FUNCTION IF EXISTS public.update_flashcard_count();

-- Usuń tabele (UWAGA: usuwa wszystkie dane!)
DROP TABLE IF EXISTS public.flashcards CASCADE;
DROP TABLE IF EXISTS public.decks CASCADE;
```

---

## 🚨 Ważne uwagi

### Bezpieczeństwo

- ✅ **NIE commituj** pliku `.env.test` do repozytorium
- ✅ Dodaj `.env.test` do `.gitignore`
- ✅ Przechowuj hasła w bezpiecznym miejscu (np. password manager)

### Backup

Przed migracją produkcyjnej bazy:

```bash
# Utwórz backup przez Dashboard lub CLI
supabase db dump -f backup.sql
```

### RLS (Row Level Security)

Projekt używa RLS do zabezpieczenia danych:
- Authenticated users → mogą zarządzać swoimi danymi
- Anonymous users → nie mają dostępu do danych
- Upewnij się, że RLS policies są aktywne po migracji!

---

## 📞 Wsparcie

Jeśli napotkasz problemy:

1. Sprawdź logi w Dashboard → Logs
2. Zweryfikuj connection string
3. Upewnij się, że masz uprawnienia do zarządzania bazą
4. Sprawdź wersję PostgreSQL (projekt używa v17)

---

## 📚 Dodatkowe materiały

- [Supabase CLI Documentation](https://supabase.com/docs/guides/cli)
- [Database Migrations](https://supabase.com/docs/guides/database/migrations)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

