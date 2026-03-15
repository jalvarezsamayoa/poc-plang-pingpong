// Define events that machines can send and receive
// Event Ping carries a payload of a tuple with the sender's identity and a sequence number
event Ping: (sender: machine, sid: int);
// Event Pong now carries a sequence number as a simple int
event Pong: int;

// Define the Pinger machine - this machine sends ping messages
machine Pinger {
    // State machine variable: stores the identity of the network machine we'll communicate through
    var network: machine;
    var timer: machine;
    var sid: int;

    // Define the initial state of the Pinger machine (marked with 'start' keyword)
    start state Init {
        // Parameter 'n' receives the LossyNetwork machine's identity
        entry (n: machine) {
            network = n;
            sid = 0;
            timer = new Timer(this);
            goto PingState;
        }
    }

    // Define the PingState - this is where the machine stays while ping-ponging
    state PingState {
        entry {
            send network, Ping, (sender = this, sid = sid);
            send timer, TimerStart;
        }
        // Event handler: when we receive a Pong event
        on Pong do (p_sid: int) {
            if (p_sid == sid) {
                send timer, TimerStop;
                sid = sid + 1;
                goto PingState;
            }
        }
        // Retransmit on timeout
        on Timeout goto PingState;
    }
}

// Define the Ponger machine - this machine responds to ping messages
machine Ponger {
    var network: machine;
    var expectedSid: int;

    // Define the initial state of the Ponger machine (marked with 'start' keyword)
    start state Init {
        entry (n: machine) {
            network = n;
            expectedSid = 0;
            goto Wait;
        }
    }

    state Wait {
        // Event handler: when we receive a Ping event, execute the 'do' action
        on Ping do (payload: (sender: machine, sid: int)) {
            if (payload.sid == expectedSid) {
                // New Ping, process it and increment expected sequence number
                print format("Ponger: Processing new Ping({0})", payload.sid);
                expectedSid = expectedSid + 1;
            } else if (payload.sid < expectedSid) {
                // Duplicate Ping, just re-acknowledge
                print format("Ponger: Received duplicate Ping({0}), re-acknowledging", payload.sid);
            }
            // Send a Pong event back through the network
            send network, Pong, payload.sid;
        }
    }
}
