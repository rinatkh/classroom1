.PHONY: run test fmt fmt-check vet lint check help

help:
	@echo "Available commands:"
	@echo "  make run       - run demo application"
	@echo "  make test      - run tests"
	@echo "  make fmt       - format Go files"
	@echo "  make fmt-check - check formatting"
	@echo "  make vet       - run go vet"
	@echo "  make lint      - run golangci-lint if installed"
	@echo "  make check     - run all checks"

run:
	go run ./cmd/app

test:
	go test ./...

fmt:
	gofmt -w $$(find . -name '*.go' -not -path './.git/*')

fmt-check:
	@test -z "$$(gofmt -l $$(find . -name '*.go' -not -path './.git/*'))" || \
	(echo "Go files are not formatted. Run: make fmt" && gofmt -l $$(find . -name '*.go' -not -path './.git/*') && exit 1)

vet:
	go vet ./...

lint:
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run ./...; \
	else \
		echo "golangci-lint is not installed locally. Install it or rely on GitHub CI."; \
	fi

check: fmt-check vet test lint
