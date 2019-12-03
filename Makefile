NAME := schematype

build:
	docker build -f Dockerfile --tag=$(NAME) ..

test: build
	docker run -t --rm $(NAME) make test

shell: build
	docker run -it --rm --entrypoint=/bin/bash $(NAME)
