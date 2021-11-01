.PHONY: qa cs cfx phpstan tests build

qa: cs phpstan

cs:
	vendor/bin/codesniffer app tests

cfx:
	vendor/bin/codefixer app tests

phpstan:
	vendor/bin/phpstan analyse -l max -c phpstan.neon --memory-limit=512M app tests/toolkit

tests:
	vendor/bin/tester -s -p php --colors 1 -C tests

tests-coverage:
	vendor/bin/tester -s -p phpdbg --colors 1 -C --coverage ./coverage.xml --coverage-src ./app tests

#####################
# LOCAL DEVELOPMENT #
#####################

setup: clean
	mkdir -p var/log var/tmp
	chmod 0777 var/tmp var/log

build:
	NETTE_DEBUG=1 bin/console orm:schema-tool:drop --force --full-database
	NETTE_DEBUG=1 bin/console migrations:migrate --no-interaction
	NETTE_DEBUG=1 bin/console doctrine:fixtures:load --no-interaction --append

clean:
	find var/tmp -mindepth 1 ! -name '.gitignore' -type f -or -type d -exec rm -rf {} +
	find var/log -mindepth 1 ! -name '.gitignore' -type f -or -type d -exec rm -rf {} +

ownEntity:
	chown -R paulik:paulik app/Entities

loc-web:
	NETTE_DEBUG=1 NETTE_ENV=dev php -S 0.0.0.0:8005 -t www

loc-postgres: loc-postgres-stop
	docker run -it -d -p 5432:5432 --name doctrine_postgres -e POSTGRES_PASSWORD=doctrine -e POSTGRES_USER=doctrine postgres:10

loc-postgres-stop:
	docker stop doctrine_postgres || true
	docker rm doctrine_postgres || true

loc-adminer: loc-adminer-stop
	docker run -it -d -p 9999:80 --name doctrine_adminer dockette/adminer:dg

loc-adminer-stop:
	docker stop doctrine_adminer || true
	docker rm doctrine_adminer || true

exec-docker-bash:
	docker exec -it rtsoft.docker.cz /bin/bash

exec-console:
	docker exec -it rtsoft.docker.cz /var/www/bin/console

exec-doctrine-mapping:
	docker exec -it rtsoft.docker.cz /var/www/bin/console orm:convert-mapping -f --from-database --namespace Entities\\Paulik\\ annotation /var/www/app

