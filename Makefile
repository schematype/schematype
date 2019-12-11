SHELL := bash

NAME := schematype

#------------------------------------------------------------------------------
build:
	docker build -f Dockerfile --tag=$(NAME) ..

test: build
	docker run -it --rm $(NAME) make test

shell: build
	docker run -it --rm $(NAME) bash

rmi:
	docker rmi $(NAME)

clean:
