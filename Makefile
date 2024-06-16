all:
	$(MAKE) build run

.PHONY: build
build:
	$(MAKE) -j5 build-app build-test build-test-webapp build-dcv-broker build-dcv-gateway

.PHONY: build-app
build-app:
	docker build --progress=plain -f infra/python-backend.Dockerfile -t containres .

.PHONY: build-test
build-test:
	docker build --progress=plain -f infra/python-backend-test.Dockerfile -t containres-test .

#.PHONY: build-webapp
#build-webapp:
	#docker build -f infra/webapp.Dockerfile -t  containres-webapp webapp

.PHONY: build-test-webapp
build-test-webapp:
	docker build --progress=plain -f infra/webapp-dev.Dockerfile -t containres-webapp-test webapp

.PHONY: build-dcv-broker
build-dcv-broker:
	docker build --progress=plain -f infra/dcv-broker.Dockerfile -t  dcv-broker infra/dcv-config

.PHONY: build-dcv-gateway
build-dcv-gateway:
	docker build --progress=plain -f infra/dcv-gateway.Dockerfile -t  dcv-gateway infra/dcv-config


.PHONY: test
test:
	docker run -it --rm containres-test

.PHONY: test
test-webapp:
	docker run -it --rm -p3000:3000 containres-webapp-test yarn run test


.PHONY: run-app-shell
run-app-shell:
	docker run -it --rm --entrypoint /bin/bash containres

.PHONY: run-test-shell
run-test-shell:
	docker run -it --rm --entrypoint /bin/bash containres-test

.PHONY: run-webapp-dev
run-webapp-dev:
	docker run -it --rm -p3000:3000 -v /home/drew/src/containres/webapp/src:/app/src --entrypoint /bin/bash containres-webapp-test

#.PHONY: run-webapp
#run-webapp:
	#docker run --rm -p8080:80 containres-webapp

run:
	docker compose -f infra/docker-compose.yaml up

run-daemon:
	docker compose -f infra/docker-compose.yaml up -d

stop:
	docker compose -f infra/docker-compose.yaml down
