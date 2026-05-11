SHELL := /usr/bin/env bash
.PHONY: test-paths validate-dist test-install test all

test-paths:
	@bash scripts/test-paths.sh

validate-dist:
	@bash scripts/test-dist.sh

test-install:
	@bash scripts/test-install.sh

test: test-paths validate-dist test-install

all: test
