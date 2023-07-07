.PHONY: all
all: build

.PHONY: build
build:
	docker build . -t modjk-security

.PHONY: run
run: build
	docker run -it --rm -p 8088:80 --name modjk-security modjk-security

.PHONY: test
test: build
	docker run -it --rm --name modjk-security modjk-security bash
