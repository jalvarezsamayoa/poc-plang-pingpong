# Plan: Port Python Helper Scripts to TypeScript

This plan covers porting the existing Python helper scripts to TypeScript to align with the rest of the project's JavaScript/TypeScript ecosystem (XState).

## Objective
- Port `scripts/trace_to_mermaid.py` to `scripts/trace_to_mermaid.ts`.
- Port `scripts/sci_to_mermaid.py` to `scripts/sci_to_mermaid.ts`.
- Update `Makefile` to use `ts-node` or `node` (after compilation) to run the scripts.
- Ensure all necessary dependencies are added to `package.json`.

## Key Files & Context
- `scripts/trace_to_mermaid.py`: Parses JSON and verbose logs to Mermaid sequence diagrams.
- `scripts/sci_to_mermaid.py`: Parses XML coverage data to Mermaid state diagrams.
- `Makefile`: References the Python scripts in `mermaid` and `graph` targets.
- `package.json`: Needs `ts-node`, `typescript`, and potentially an XML parser like `xml2js` or `fast-xml-parser`.

## Implementation Steps

### 1. Update Dependencies
- Add `typescript`, `ts-node`, `@types/node`, and an XML parser (e.g., `fast-xml-parser`) to `devDependencies`.

### 2. Port `trace_to_mermaid.py` to TypeScript
- Implement the JSON and text log parsing logic in TypeScript.
- Save as `scripts/trace_to_mermaid.ts`.

### 3. Port `sci_to_mermaid.py` to TypeScript
- Implement the XML parsing logic using a Node.js library.
- Save as `scripts/sci_to_mermaid.ts`.

### 4. Update `Makefile`
- Update the `mermaid` and `graph` targets to use `npx ts-node scripts/*.ts` instead of `python3 scripts/*.py`.

### 5. Verification
- Run `make trace` followed by `make mermaid`.
- Run `make check` followed by `make graph`.
- Verify the generated `.mermaid` files.

### 6. Cleanup
- Remove the old Python scripts.

## Verification & Testing
| Feature | Command | Expected Result |
|---------|---------|-----------------|
| Trace to Mermaid | `make mermaid` | Correct `trace.mermaid` generated via TS. |
| SCI to Mermaid | `make graph` | Correct `graph.mermaid` generated via TS. |
