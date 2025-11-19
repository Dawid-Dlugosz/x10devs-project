#!/bin/bash

# Skrypt do łączenia z projektem Supabase i wykonania migracji
# Project ID: iapmykfcsntlqfxqwcoh
# Użycie: ./setup_remote_db.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_REF="iapmykfcsntlqfxqwcoh"
PROJECT_URL="https://iapmykfcsntlqfxqwcoh.supabase.co"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Supabase Remote Database Setup          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Project ID:  ${GREEN}${PROJECT_REF}${NC}"
echo -e "Project URL: ${GREEN}${PROJECT_URL}${NC}"
echo ""

# Sprawdź czy Supabase CLI jest zainstalowane
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ ERROR: Supabase CLI is not installed${NC}"
    echo ""
    echo "Install it with:"
    echo "  brew install supabase/tap/supabase"
    echo ""
    echo "Or visit: https://supabase.com/docs/guides/cli"
    exit 1
fi

echo -e "${GREEN}✓ Supabase CLI found${NC}"
SUPABASE_VERSION=$(supabase --version)
echo -e "  Version: ${SUPABASE_VERSION}"
echo ""

# Sprawdź czy projekt jest już zlinkowany
if [ -f ".branches/_current_branch" ]; then
    echo -e "${YELLOW}⚠️  Project is already linked${NC}"
    echo ""
    read -p "Do you want to re-link the project? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Skipping link step...${NC}"
    else
        echo -e "${BLUE}Re-linking project...${NC}"
        supabase link --project-ref "$PROJECT_REF"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully linked${NC}"
        else
            echo -e "${RED}❌ Failed to link project${NC}"
            exit 1
        fi
    fi
else
    echo -e "${BLUE}Linking to remote project...${NC}"
    echo ""
    supabase link --project-ref "$PROJECT_REF"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Successfully linked to project${NC}"
    else
        echo ""
        echo -e "${RED}❌ Failed to link project${NC}"
        echo ""
        echo "Make sure you're logged in:"
        echo "  supabase login"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}Running database migrations...${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

# Wyświetl dostępne migracje
MIGRATIONS_DIR="./supabase/migrations"
if [ -d "$MIGRATIONS_DIR" ]; then
    echo -e "${BLUE}Migrations to apply:${NC}"
    ls -1 "$MIGRATIONS_DIR"/*.sql 2>/dev/null | while read file; do
        echo "  📄 $(basename "$file")"
    done
    echo ""
fi

# Wykonaj migracje
supabase db push

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✅ Migration completed successfully!     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Your database schema has been updated."
    echo ""
    echo "Next steps:"
    echo "  1. Verify tables in Dashboard: ${PROJECT_URL}"
    echo "  2. Check RLS policies are enabled"
    echo "  3. Update your .env or .env.test with connection details"
    echo ""
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   ❌ Migration failed                      ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Check the error messages above for details."
    echo ""
    echo "Common issues:"
    echo "  - Database password might be required"
    echo "  - Migrations might already be applied"
    echo "  - Network connection issues"
    echo ""
    exit 1
fi

