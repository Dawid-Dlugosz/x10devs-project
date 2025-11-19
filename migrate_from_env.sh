#!/bin/bash

# Skrypt do migracji bazy danych z użyciem danych z .env.test
# Project ID: iapmykfcsntlqfxqwcoh
# Użycie: ./migrate_from_env.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_REF="iapmykfcsntlqfxqwcoh"

echo -e "${BLUE}🚀 Database Migration Script${NC}"
echo -e "Project: ${GREEN}${PROJECT_REF}${NC}"
echo ""

# Sprawdź czy plik .env.test istnieje
if [ ! -f ".env.test" ]; then
    echo -e "${RED}❌ ERROR: .env.test file not found${NC}"
    echo "Please create .env.test with your database credentials"
    exit 1
fi

# Załaduj zmienne z .env.test
echo -e "${BLUE}Loading configuration from .env.test...${NC}"
export $(cat .env.test | grep -v '^#' | xargs)

# Sprawdź czy wymagane zmienne są ustawione
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ ERROR: Required variables not found in .env.test${NC}"
    echo "Please ensure .env.test contains:"
    echo "  - SUPABASE_URL"
    echo "  - SUPABASE_ANON_KEY"
    echo "  - SUPABASE_DATABASE_URL (optional, for direct database access)"
    exit 1
fi

echo -e "${GREEN}✓ Configuration loaded${NC}"
echo -e "  Supabase URL: ${SUPABASE_URL}"
echo ""

# Sprawdź czy jest dostępny bezpośredni connection string
if [ -n "$SUPABASE_DATABASE_URL" ]; then
    echo -e "${BLUE}Found database connection string. Using direct database migration...${NC}"
    export DATABASE_URL="$SUPABASE_DATABASE_URL"
    ./migrate.sh
else
    echo -e "${YELLOW}⚠️  No direct database URL found in .env.test${NC}"
    echo ""
    echo "To migrate using direct database connection, add to .env.test:"
    echo "  SUPABASE_DATABASE_URL='postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/postgres'"
    echo ""
    echo "You can find this in your Supabase Dashboard:"
    echo "  Project Settings → Database → Connection string → URI"
    echo ""
    echo -e "${BLUE}Alternative: Use Supabase CLI${NC}"
    echo "  1. Link your project: supabase link --project-ref [YOUR-PROJECT-REF]"
    echo "  2. Push migrations: supabase db push"
    exit 1
fi

