ZIG := zig
ZIG_OUT := "./zig-out/"
ZIG_CACHE_DIR := "./zig-cache/"
ZIG_CACHE_HIDDEN_DIR := "./.zig-cache/"
ZIG_TEST_DIR := "./tests/"
ZIG_TEST_OUT_DIR := "./test-out/"
ZIG_KCOV_DIR := "./.coverage/"
PKG_MANAGER ?= $(shell command -v dnf yum|head -n1)
PRE_COMMIT = $(shell command -v bin/venv/bin/pre-commit ~/.local/bin/pre-commit pre-commit | head -n1)


.PHONY: build
build: ## Build
	$(ZIG) build

.PHONY: docs
docs: ## Generate documentations
	$(ZIG) build docs

.PHONY: clean
clean:
	@rm -rf $(ZIG_OUT)
	@rm -rf $(ZIG_CACHE_DIR)
	@rm -rf $(ZIG_CACHE_HIDDEN_DIR)
	@rm -rf $(ZIG_KCOV_DIR)
	@rm -rf $(ZIG_TEST_OUT_DIR)

.PHONY: validate
validate: pre-commit codespell fmt test ## validate pre-commit, codespell, fmt and unit test

#=================================================
# Required tools installation tartgets
#=================================================

.PHONY: install.tools
install.tools: .install.pre-commit .install.codespell .install.kcov ## Install needed tools

.PHONY: .install.pre-commit
.install.pre-commit:
	if [ -z "$(PRE_COMMIT)" ]; then \
		python3 -m pip install --user pre-commit; \
	fi

.PHONY: .install.codespell
.install.codespell:
	sudo ${PKG_MANAGER} -y install codespell

.PHONY: .install.kcov
.install.kcov:
	sudo ${PKG_MANAGER} -y install kcov

#=================================================
# Testing (units, functionality, ...) targets
#=================================================

.PHONY: test
test: ## Run unit tests and generate code coverage
	$(ZIG) build test

.PHONY: coverage
coverage: test ## Generates coverage report from unit tests
	$(ZIG) build cov

#=================================================
# Linting/Formatting/Code Validation targets
#=================================================

.PHONY: pre-commit
pre-commit:   ## Run pre-commit
ifeq ($(PRE_COMMIT),)
	@echo "FATAL: pre-commit was not found, make .install.pre-commit to installing it." >&2
	@exit 2
endif
	$(PRE_COMMIT) run -a

.PHONY: fmt
fmt: ## Check formatting
	$(ZIG) build fmt

.PHONY: codespell
codespell: ## Run codespell
	@echo "running codespell"
	@codespell -S ./vendor,go.mod,go.sum,./.git,*_test.go

_HLP_TGTS_RX = '^[[:print:]]+:.*?\#\# .*$$'
_HLP_TGTS_CMD = grep -E $(_HLP_TGTS_RX) $(MAKEFILE_LIST)
_HLP_TGTS_LEN = $(shell $(_HLP_TGTS_CMD) | cut -d : -f 1 | wc -L)
_HLPFMT = "%-$(_HLP_TGTS_LEN)s %s\n"
.PHONY: help
help: ## Print listing of key targets with their descriptions
	@printf $(_HLPFMT) "Target:" "Description:"
	@printf $(_HLPFMT) "--------------" "--------------------"
	@$(_HLP_TGTS_CMD) | sort | \
		awk 'BEGIN {FS = ":(.*)?## "}; \
			{printf $(_HLPFMT), $$1, $$2}'
