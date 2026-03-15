# Implementation Plan: Reliable Delivery Protocol

## Phase 1: Environment Setup & Lossy Network [checkpoint: bee79f8]
- [x] Task: Define a `LossyNetwork` machine that intercepts events between Pinger and Ponger. [254ebcf]
- [x] Task: Add a probability factor to `LossyNetwork` to drop events. [600c933]
- [x] Task: Update `Main` machine to route traffic through the `LossyNetwork`. [e7f59d1]
- [x] Task: Conductor - User Manual Verification 'Phase 1: Environment Setup & Lossy Network' (Protocol in workflow.md) [bee79f8]

## Phase 2: Reliable Protocol Logic [checkpoint: cd83fb2]
- [x] Task: Update event definitions to include sequence numbers. [ecaf2e2]
- [x] Task: Implement retransmission timers in the `Pinger` machine. [6097f25]
- [x] Task: Implement acknowledgment logic in the `Ponger` machine. [ecd0ccb]
- [x] Task: Add sequence number tracking to the `Ponger` to ignore duplicates. [ecd0ccb]
- [x] Task: Conductor - User Manual Verification 'Phase 2: Reliable Protocol Logic' (Protocol in workflow.md) [cd83fb2]


## Phase 3: Verification & Visualization
- [x] Task: Update `LivenessMonitor` to handle the new reliable delivery events. [176c19e]
- [x] Task: Run `make check` to verify the model under lossy conditions. [176c19e]
- [~] Task: Run `make trace` and `make mermaid` to visualize a successful reliable delivery trace.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Verification & Visualization' (Protocol in workflow.md)
