-- Seed file for test data
-- This file is used to populate the database with test data for E2E tests
-- Run with: supabase db reset (will run migrations + seed)

-- Clean up existing test data (if any)
DELETE FROM flashcards WHERE deck_id IN (SELECT id FROM decks WHERE user_id IN (
  SELECT id FROM auth.users WHERE email LIKE 'test%@example.com'
));
DELETE FROM decks WHERE user_id IN (
  SELECT id FROM auth.users WHERE email LIKE 'test%@example.com'
);

-- Note: Test users will be created dynamically in E2E tests
-- This is because Supabase auth requires proper signup flow

-- Insert sample decks for manual testing (optional)
-- These will be associated with users created during tests
-- Uncomment if you want pre-populated data for manual testing

-- Example:
-- INSERT INTO decks (name, user_id, flashcard_count) VALUES
--   ('Sample Deck 1', 'user-id-here', 0),
--   ('Sample Deck 2', 'user-id-here', 0);

-- Note: For E2E tests, we will:
-- 1. Create test users dynamically (unique emails with timestamps)
-- 2. Create test decks and flashcards in each test
-- 3. Clean up after each test by deleting the test user (CASCADE will handle the rest)

