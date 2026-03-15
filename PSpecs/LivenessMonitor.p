// LivenessMonitor: A P 'spec' (formerly 'monitor') that tracks 
// the history of events across the entire system.
spec LivenessMonitor observes Ping, Pong {
    // The spec starts in this state, waiting for the first Ping.
    start state WaitingForPing {
        on Ping do (p: machine) {
            print format("TRACE: Ping from {0}", p);
            goto WaitingForPong;
        }
    }

    // A 'hot' state means that the system is in an "incomplete" or "pending" state.
    hot state WaitingForPong {
        on Pong do {
            print "TRACE: Pong";
            goto WaitingForPing;
        }

        on Ping do (p: machine) {
            print format("TRACE: Ping from {0}", p);
        } 
    }
}
