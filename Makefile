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

.PHONY: all compile check clean help setup

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

## trace: Run a single schedule and capture a verbose log (even if no bugs found)
trace:
	@echo "==> Generating verbose trace log..."
	$(P_TOOL) check $(DLL_PATH) -s 1 -v -ms 10 > PCheckerOutput/verbose.log 2>&1
	@echo "Log created: PCheckerOutput/verbose.log"

## mermaid: Export the trace to a Mermaid diagram (checks for log or JSON)
mermaid:
	@if [ -f PCheckerOutput/verbose.log ]; then \
		echo "==> Exporting verbose log to Mermaid..."; \
		python3 scripts/trace_to_mermaid.py PCheckerOutput/verbose.log > PCheckerOutput/trace.mermaid; \
		echo "Created PCheckerOutput/trace.mermaid"; \
	elif [ -f $$(ls $(OUTPUT_DIR)/BugFinding/*.trace.json 2>/dev/null | head -n 1) ]; then \
		JSON_FILE=$$(ls $(OUTPUT_DIR)/BugFinding/*.trace.json 2>/dev/null | head -n 1); \
		echo "==> Exporting bug JSON trace $$JSON_FILE to Mermaid..."; \
		python3 scripts/trace_to_mermaid.py "$$JSON_FILE" > PCheckerOutput/trace.mermaid; \
		echo "Created PCheckerOutput/trace.mermaid"; \
	else \
		echo "Error: No trace found. Run 'make trace' or 'make check' first."; \
		exit 1; \
	fi

## graph: Export the state machines to a Mermaid state diagram
graph:
	@SCI_FILE=$$(ls $(OUTPUT_DIR)/BugFinding/*.sci 2>/dev/null | head -n 1); \
	if [ -z "$$SCI_FILE" ]; then \
		echo "Error: No SCI file found. Run 'make check' first."; \
		exit 1; \
	fi; \
	echo "==> Exporting state machines from $$SCI_FILE to Mermaid..."; \
	python3 scripts/sci_to_mermaid.py $$SCI_FILE > PCheckerOutput/graph.mermaid; \
	echo "Created PCheckerOutput/graph.mermaid"

## compile-viz: Compile the project in stately mode to generate the visualization JSON (via npm)
compile-viz:
	@echo "==> Compiling for visualization..."
	npm run viz

## setup: Install development dependencies
setup:
	@echo "==> Installing Node.js dependencies..."
	npm install --silent

## clean: Remove all generated artifacts (compiler and checker output)
clean:
	@echo "==> Cleaning up..."
	rm -rf $(GEN_DIR)
	rm -rf $(OUTPUT_DIR)
	@echo "Cleaned."
