# Technology Stack

## Core Modeling & Verification
- **P Programming Language**: Used for high-level modeling of asynchronous distributed systems.
- **P-Checker**: Formal verification toolchain running on .NET 8.0, used for safety and liveness checks.

## Scripting & Tooling
- **TypeScript**: Used for writing robust helper scripts to transform P artifacts into visualizations.
- **Node.js**: The runtime environment for TypeScript utilities (`ts-node`) and dependency management (`npm`).
- **Makefile**: Used for orchestrating the build, verification, and visualization pipeline.

## Visualization
- **XState**: The industry-standard library for finite state machines in JavaScript/TypeScript, used as a target for P model animations.
- **Mermaid**: A Markdown-based diagramming tool used for generating static state graphs and dynamic interaction traces.
- **Stately Visualizer**: A web-based tool for animating XState machines.
