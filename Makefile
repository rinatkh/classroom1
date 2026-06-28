SHELL := /bin/bash

GO ?= go
GO_PACKAGES := ./...
APP_PATH := ./cmd/app
APP_BIN := bin/app
PACKAGE_FILE := bin/app-linux-amd64.tar.gz
LOCAL_BIN := $(CURDIR)/bin
GOLANGCI_LINT := $(LOCAL_BIN)/golangci-lint
GOLANGCI_LINT_VERSION ?= v1.64.8
GOLANGCI_LINT_VERSION_NO_V := $(patsubst v%,%,$(GOLANGCI_LINT_VERSION))
GOLANGCI_LINT_DOWNLOAD_URL ?=
GO_TEST_FLAGS ?= -race -covermode=atomic -coverprofile=coverage.out
GO_FILES := $(shell find . -type f -name '*.go' \
	-not -path './.git/*' \
	-not -path './bin/*')

.PHONY: help run build package test test-ci cover fmt fmt-check vet lint tools clean check ci

help:
	@echo "Available commands:"
	@echo "  make run       - run demo application"
	@echo "  make build     - build demo binary"
	@echo "  make package   - build tar.gz artifact"
	@echo "  make test      - run unit tests"
	@echo "  make test-ci   - run tests with race detector and coverage"
	@echo "  make cover     - show coverage summary"
	@echo "  make fmt       - format Go files"
	@echo "  make fmt-check - check formatting without changing files"
	@echo "  make vet       - run go vet"
	@echo "  make lint      - run strict golangci-lint checks"
	@echo "  make check     - run local checks"
	@echo "  make ci        - run the same checks as GitHub CI"
	@echo "  make clean     - remove generated artifacts"

run:
	$(GO) run $(APP_PATH)

build:
	@mkdir -p bin
	$(GO) build -o $(APP_BIN) $(APP_PATH)

package: build
	tar -czf $(PACKAGE_FILE) -C bin app

test:
	$(GO) test $(GO_PACKAGES)

test-ci:
	$(GO) test $(GO_TEST_FLAGS) $(GO_PACKAGES)

cover: test-ci
	$(GO) tool cover -func=coverage.out

fmt:
	gofmt -w $(GO_FILES)

fmt-check:
	@files="$$(gofmt -l $(GO_FILES))"; \
	if [[ -n "$$files" ]]; then \
		echo "Go files are not formatted. Run: make fmt"; \
		echo "$$files"; \
		exit 1; \
	fi

vet:
	$(GO) vet $(GO_PACKAGES)

tools:
	@mkdir -p "$(LOCAL_BIN)"
	@if [[ ! -x "$(GOLANGCI_LINT)" ]]; then \
		tmp_dir="$$(mktemp -d)"; \
		trap 'rm -rf "$$tmp_dir"' EXIT; \
		os="$$(uname -s | tr '[:upper:]' '[:lower:]')"; \
		arch="$$(uname -m)"; \
		case "$$os" in \
			darwin|linux) ;; \
			*) echo "Unsupported OS for golangci-lint archive: $$os"; exit 1 ;; \
		esac; \
		case "$$arch" in \
			x86_64|amd64) arch="amd64" ;; \
			aarch64|arm64) arch="arm64" ;; \
			*) echo "Unsupported architecture for golangci-lint archive: $$arch"; exit 1 ;; \
		esac; \
		archive="golangci-lint-$(GOLANGCI_LINT_VERSION_NO_V)-$$os-$$arch.tar.gz"; \
		url="$(GOLANGCI_LINT_DOWNLOAD_URL)"; \
		if [[ -z "$$url" ]]; then \
			url="https://github.com/golangci/golangci-lint/releases/download/$(GOLANGCI_LINT_VERSION)/$$archive"; \
		fi; \
		echo "Installing golangci-lint $(GOLANGCI_LINT_VERSION) from $$url"; \
		curl -fsSL "$$url" -o "$$tmp_dir/$$archive"; \
		tar -xzf "$$tmp_dir/$$archive" -C "$$tmp_dir"; \
		binary="$$(find "$$tmp_dir" -type f -name golangci-lint | head -n 1)"; \
		if [[ -z "$$binary" ]]; then \
			echo "golangci-lint binary was not found inside $$archive"; \
			exit 1; \
		fi; \
		cp "$$binary" "$(GOLANGCI_LINT)"; \
		chmod +x "$(GOLANGCI_LINT)"; \
	fi

lint: tools
	"$(GOLANGCI_LINT)" run $(GO_PACKAGES)

lint: tools
	"$(GOLANGCI_LINT)" run $(GO_PACKAGES)

lint: tools
	"$(GOLANGCI_LINT)" run $(GO_PACKAGES)

check: fmt-check vet test lint

ci: fmt-check vet test-ci lint build

clean:
	rm -rf bin coverage.out
