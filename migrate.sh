#!/bin/bash

# Skrypt do migracji bazy danych Supabase
# Użycie: ./migrate.sh

set -e

echo "🚀 Starting database migration..."

# Kolory do outputu
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Sprawdź czy DATABASE_URL jest ustawiony
if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}❌ ERROR: DATABASE_URL is not set${NC}"
    echo "Please set DATABASE_URL environment variable or export it from .env.test"
    echo ""
    echo "Example:"
    echo "  export DATABASE_URL='postgresql://postgres:[YOUR-PASSWORD]@[HOST]:[PORT]/postgres'"
    exit 1
fi

# Katalog z migracjami
MIGRATIONS_DIR="./supabase/migrations"

# Sprawdź czy katalog istnieje
if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo -e "${RED}❌ ERROR: Migrations directory not found: $MIGRATIONS_DIR${NC}"
    exit 1
fi

# Pobierz wszystkie pliki migracji i posortuj je
MIGRATION_FILES=$(ls "$MIGRATIONS_DIR"/*.sql 2>/dev/null | sort)

if [ -z "$MIGRATION_FILES" ]; then
    echo -e "${RED}❌ ERROR: No migration files found in $MIGRATIONS_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Found migrations:${NC}"
for file in $MIGRATION_FILES; do
    echo "  - $(basename "$file")"
done
echo ""

# Wykonaj każdą migrację
for migration_file in $MIGRATION_FILES; do
    filename=$(basename "$migration_file")
    echo -e "${BLUE}Applying migration: $filename${NC}"
    
    # Wykonaj migrację
    psql "$DATABASE_URL" -f "$migration_file"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully applied: $filename${NC}"
    else
        echo -e "${RED}❌ Failed to apply: $filename${NC}"
        exit 1
    fi
    echo ""
done

echo -e "${GREEN}✅ All migrations completed successfully!${NC}"

