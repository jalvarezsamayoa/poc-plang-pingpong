# Plan: Graphical Representation of P State Machines and Interactions

This plan documents the implementation and verification of automated visualization tools for the PingPong project. These tools convert P checker artifacts (logs and coverage data) into Mermaid diagrams.

## Objective
Provide a seamless workflow for generating:
1. **Sequence Diagrams**: Showing the runtime interaction and event flow between machines.
2. **State Machine Diagrams**: Showing the static internal logic, states, and transitions of each machine.

## Key Files & Context
- `scripts/trace_to_mermaid.py`: Converts JSON/text traces into sequence diagrams.
- `scripts/sci_to_mermaid.py`: Converts XML coverage data (`.sci`) into state diagrams.
- `Makefile`: Provides `make trace`, `make mermaid`, and `make graph` targets.
- `.vscode/tasks.json`: Provides VS Code integration for these commands.
- `PCheckerOutput/`: The destination for all generated `.mermaid` files.

## Implementation Steps

### 1. Verification of Sequence Diagram Export
- Run `make trace` to generate a successful execution log (`PCheckerOutput/verbose.log`).
- Run `make mermaid` to verify the log is correctly parsed and `PCheckerOutput/trace.mermaid` is created.
- Validate the output format at [Mermaid Live Editor](https://mermaid.live/).

### 2. Verification of State Machine Diagram Export
- Run `make check` to ensure the `.sci` coverage file is generated in `PCheckerOutput/BugFinding/`.
- Run `make graph` to verify the structure is correctly extracted and `PCheckerOutput/graph.mermaid` is created.
- Validate the state machine nesting and transition labels.

### 3. Cleanup & Integration
- Ensure all temporary `.mermaid` files are stored in `PCheckerOutput/`.
- Verify that `PCheckerOutput/` remains in `.gitignore`.
- Confirm that `.vscode/tasks.json` correctly points to the `Makefile` targets.

## Verification & Testing
| Feature | Command | Expected Result |
|---------|---------|-----------------|
| Trace Generation | `make trace` | `PCheckerOutput/verbose.log` exists |
| Sequence Diagram | `make mermaid` | `PCheckerOutput/trace.mermaid` contains `sequenceDiagram` |
| State Diagram | `make graph` | `PCheckerOutput/graph.mermaid` contains `stateDiagram-v2` |
| VS Code Task | Run "P: Export State Graph" | Task completes and generates file |
