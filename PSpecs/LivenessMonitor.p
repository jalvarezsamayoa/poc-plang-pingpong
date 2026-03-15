// LivenessMonitor: A P 'spec' that tracks 
// the history of events across the entire system.
spec LivenessMonitor observes Ping, Pong {
    var lastPingSid: int;

    // The spec starts in this state, waiting for the first Ping.
    start state WaitingForPing {
        on Ping do (payload: (sender: machine, sid: int)) {
            // We only care about the transition to WaitingForPong
            // if this is a new Ping (the first time we see this sid).
            // However, since we increment sid in each round, 
            // any Ping we see while in WaitingForPing is technically "new" 
            // relative to the previous Pong we received.
            lastPingSid = payload.sid;
            print format("TRACE: Ping({1}) observed", payload.sender, payload.sid);
            goto WaitingForPong;
        }
        on Pong do (sid: int) {
            // Ignore stale Pongs from previous rounds
        }
    }

    // A 'hot' state means that the system is in an "incomplete" or "pending" state.
    hot state WaitingForPong {
        on Pong do (sid: int) {
            if (sid == lastPingSid) {
                print format("TRACE: Pong({0}) observed", sid);
                goto WaitingForPing;
            }
            // else: ignore duplicate Pongs for older sids
        }

        on Ping do (payload: (sender: machine, sid: int)) {
            // In a lossy network with retransmissions, we will see multiple Pings
            // for the same sid. This is normal.
            if (payload.sid > lastPingSid) {
                // This shouldn't happen in our FIFO-ish model unless progress was made
                // but we missed the Pong observation somehow? 
                // Let's be robust but keep the core logic.
                lastPingSid = payload.sid;
            }
        } 
    }
}
