# Product Guidelines

## Prose Style
- **Clarity and Precision**: Documentation should be concise and use precise terminology consistent with formal methods and distributed systems.
- **Educational Tone**: Since this is a demonstration project, explanations should be pedagogical, explaining *why* certain modeling choices were made.
- **Markdown Consistency**: Use consistent Markdown formatting for headers, code blocks, and lists.

## Design Principles
- **Separation of Concerns**: Keep formal logic (machines) strictly separated from specifications (monitors).
- **Modularity**: Model components as independent state machines that communicate solely through asynchronous events.
- **Visual first**: Ensure every new feature or state change is accompanied by corresponding updates to visualization scripts.

## Verification Standards
- **Liveness Guarantee**: Every model must have at least one liveness monitor to prevent silent deadlocks or infinite loops without progress.
- **Safety First**: Use assertions within state machine logic to catch invalid states immediately.
- **Traceability**: Every bug found by the P checker should be reproducible and visualized using the Mermaid trace tool.
