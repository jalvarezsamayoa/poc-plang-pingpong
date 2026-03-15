# P Project Makefile
# ------------------
# This Makefile provides a standard interface for building and 
# verifying the P model for the PingPong project.

# Project Configuration
PROJECT_NAME = PingPong
PPROJ = $(PROJECT_NAME).pproj
GEN_DIR = PGenerated
CHECKER_DIR = $(GEN_DIR)/PChecker/net8.0
DLL_PATH = $(CHECKER_DIR)/$(PROJECT_NAME).dll
OUTPUT_DIR = PCheckerOutput

# Tools
P_TOOL = p

.PHONY: all compile check clean help

all: compile check

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk '/^## / { \
		helpMsg = substr($$0, 4); \
		getline; \
		if ($$0 ~ /:/) { \
			split($$0, a, ":"); \
			printf "  \033[36m%-15s\033[0m %s\n", a[1], helpMsg; \
		} \
	}' $(MAKEFILE_LIST)

## compile: Compile the P source files into a .NET DLL using .pproj
compile:
	@echo "==> Compiling P files..."
	$(P_TOOL) compile -pp $(PPROJ)

## check: Run the P model checker on the compiled DLL
check: 
	@if [ ! -f $(DLL_PATH) ]; then \
		echo "Error: $(DLL_PATH) not found. Run 'make compile' first."; \
		exit 1; \
	fi
	@echo "==> Running P Checker..."
	$(P_TOOL) check $(DLL_PATH)

## clean: Remove all generated artifacts (compiler and checker output)
clean:
	@echo "==> Cleaning up..."
	rm -rf $(GEN_DIR)
	rm -rf $(OUTPUT_DIR)
	@echo "Cleaned."
