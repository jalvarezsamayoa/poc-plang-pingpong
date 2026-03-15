# Specification: Reliable Delivery Protocol

## Objective
Implement a reliable delivery abstraction in the PingPong P model to ensure that messages between Pinger and Ponger are not lost or reordered in a simulated lossy environment.

## Requirements
- **Acknowledgement Loop**: Implement a sequence-number-based acknowledgment system.
- **Retransmission Logic**: Add timers to machines to handle retransmissions upon timeout.
- **Lossy Environment Simulation**: Introduce a proxy machine or a faulty network model that randomly drops events.
- **Safety Properties**: Verify that the receiver never processes duplicate sequence numbers.
- **Liveness Properties**: Ensure that despite network drops, the system eventually makes progress (messages are delivered).
