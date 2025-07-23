SHELL := /bin/bash

.PHONY: test
test:
	go test -v -timeout 30m

.PHONY: init
init:
	go mod tidy

.PHONY: clean
clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*

.PHONY: all
all: init test