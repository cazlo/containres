build:
	$(MAKE) -j2 build-app build-test

build-app:
	docker build -t containres .

build-test:
	docker build -f Dockerfile.test -t containres-test .

test:
	docker run -it --rm containres-test

run-app-shell:
	docker run -it --rm --entrypoint /bin/bash containres

run-test-shell:
	docker run -it --rm --entrypoint /bin/bash containres-test