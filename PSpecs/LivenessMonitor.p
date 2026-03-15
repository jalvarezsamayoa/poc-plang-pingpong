// LivenessMonitor: A P 'spec' (formerly 'monitor') that tracks 
// the history of events across the entire system.
spec LivenessMonitor observes Ping, Pong {
    // The spec starts in this state, waiting for the first Ping.
    start state WaitingForPing {
        on Ping do (payload: (sender: machine, sid: int)) {
            print format("TRACE: Ping({1}) from {0}", payload.sender, payload.sid);
            goto WaitingForPong;
        }
        on Pong do (sid: int) {
            // Ignore stale Pongs
        }
    }

    // A 'hot' state means that the system is in an "incomplete" or "pending" state.
    hot state WaitingForPong {
        on Pong do (sid: int) {
            print format("TRACE: Pong({0})", sid);
            goto WaitingForPing;
        }

        on Ping do (payload: (sender: machine, sid: int)) {
            print format("TRACE: Ping({1}) from {0}", payload.sender, payload.sid);
        } 
    }
}
