.PHONY: up upt volumes down restart setup deploy clear-cache composer-install composer-require composer-dumpautoload build unit unitf unitf-pretty unit-retry coverage coverage-html migrate route user database-login sh-app fix-ssl exec

VERSION := $(shell cat VERSION)


up:
	@./vendor/bin/sail up -d


setup:
	@echo "⚡️ Copying .env.example to .env"
	@echo ""
	@cp -n .env.example .env
	@echo "⚡️ Installing composer dependencies"
	@echo ""
	@docker run --rm -u "$$(id -u):$$(id -g)" -v $$(pwd):/opt -w /opt laravelsail/php80-composer:latest composer install --ignore-platform-reqs --no-cache
	@echo "⚡️ Generating Application key"
	@echo ""
	@docker run --rm -u "$$(id -u):$$(id -g)" -v $$(pwd):/opt -w /opt laravelsail/php80-composer:latest php artisan key:generate --force
	@echo "⚡️ Starting Docker container (Sail)"
	@echo ""
	@./vendor/bin/sail up -d
	@echo "⚡️ Migrating database"
	@echo ""
	@./vendor/bin/sail artisan migrate --seed
	@echo ""

composer-install:
	@echo "⚡️ Installing composer dependencies"
	@echo ""
	@docker run --rm -u "$$(id -u):$$(id -g)" -v $$(pwd):/opt -w /opt laravelsail/php80-composer:latest composer install --ignore-platform-reqs --no-cache

composer-update:
	@echo "⚡️ Updating composer dependencies"
	@echo ""
	@mkdir -p .composer
	@docker run --rm -u "$$(id -u):$$(id -g)" -v $$(pwd):/opt -v $$(pwd)/.composer:/.composer -w /opt laravelsail/php80-composer:latest composer update --ignore-platform-reqs
