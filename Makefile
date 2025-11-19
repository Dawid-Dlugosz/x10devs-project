.PHONY: help setup test test-unit test-widget test-e2e test-all clean db-start db-stop db-reset coverage

# Default target
help:
	@echo "Available commands:"
	@echo "  make setup        - Install dependencies and setup environment"
	@echo "  make db-start     - Start local Supabase instance"
	@echo "  make db-stop      - Stop local Supabase instance"
	@echo "  make db-reset     - Reset database (run migrations + seed)"
	@echo "  make test-unit    - Run unit tests"
	@echo "  make test-widget  - Run widget tests"
	@echo "  make test-e2e     - Run E2E tests"
	@echo "  make test-all     - Run all tests"
	@echo "  make coverage     - Generate test coverage report"
	@echo "  make clean        - Clean build artifacts"

# Setup project
setup:
	@echo "📦 Installing Flutter dependencies..."
	flutter pub get
	@echo "🔧 Running code generation..."
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "✅ Setup complete!"

# Database commands
db-start:
	@echo "🚀 Starting local Supabase..."
	supabase start
	@echo "✅ Supabase is running!"
	@echo "   Studio: http://localhost:54323"
	@echo "   API: http://localhost:54321"

db-stop:
	@echo "🛑 Stopping local Supabase..."
	supabase stop

db-reset:
	@echo "🔄 Resetting database..."
	supabase db reset
	@echo "✅ Database reset complete!"

# Test commands
test-unit:
	@echo "🧪 Running unit tests..."
	flutter test test/ --exclude-tags=widget,e2e

test-widget:
	@echo "🎨 Running widget tests..."
	flutter test test/ --tags=widget

test-e2e:
	@echo "🚀 Running E2E tests..."
	@echo "⚠️  Make sure Supabase is running (make db-start)"
	@echo "⚠️  Note: Run tests individually due to Flutter integration_test limitations"
	@echo "   Example: make test-e2e-auth-001"
	flutter test integration_test/

# Run individual E2E tests (workaround for Flutter integration_test limitation)
test-e2e-auth-001:
	flutter test integration_test/auth_flow_test.dart --name "TC-E2E-AUTH-001" -d emulator-5554

test-e2e-auth-all-sequential:
	@echo "🧪 Running all auth tests sequentially..."
	@for i in 001 004 007 008 009 010; do \
		echo "Running TC-E2E-AUTH-$$i..."; \
		flutter test integration_test/auth_flow_test.dart --name "TC-E2E-AUTH-$$i" -d emulator-5554 || true; \
	done

test-all:
	@echo "🧪 Running all tests..."
	@$(MAKE) test-unit
	@$(MAKE) test-widget
	@$(MAKE) test-e2e

# Coverage
coverage:
	@echo "📊 Generating coverage report..."
	flutter test --coverage
	@echo "📈 Generating HTML report..."
	genhtml coverage/lcov.info -o coverage/html
	@echo "✅ Coverage report generated!"
	@echo "   Open: coverage/html/index.html"

# Clean
clean:
	@echo "🧹 Cleaning build artifacts..."
	flutter clean
	rm -rf coverage/
	rm -rf build/
	@echo "✅ Clean complete!"

# Development workflow
dev: db-start
	@echo "🚀 Starting development environment..."
	@echo "   Supabase: http://localhost:54323"
	@echo "   Run: flutter run -d chrome"

# Test workflow (for CI/CD)
ci-test: setup db-start test-all db-stop
	@echo "✅ CI tests complete!"

