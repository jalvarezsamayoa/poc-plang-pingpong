// Event to configure the lossy network with the machines it's mediating between
event Config: (p: machine, po: machine);

// LossyNetwork: Intercepts and potentially drops events between machines.
machine LossyNetwork {
    var pinger: machine;
    var ponger: machine;

    start state Init {
        defer Ping, Pong;
        on Config do (payload: (p: machine, po: machine)) {
            pinger = payload.p;
            ponger = payload.po;
            goto Active;
        }
    }

    state Active {
        on Ping do (payload: (sender: machine, sid: int)) {
            if ($) {
                // Non-deterministically choose to forward the event
                send ponger, Ping, payload;
            }
            // else: silently drop the event
        }

        on Pong do (sid: int) {
            if ($) {
                // Non-deterministically choose to forward the event
                send pinger, Pong, sid;
            }
            // else: silently drop the event
        }
    }
}
