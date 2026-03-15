// Define events that machines can send and receive
// Event Ping carries a payload of type 'machine' (the sender's identity)
event Ping: machine;
// Event Pong has no payload
event Pong;

// Define the Pinger machine - this machine sends ping messages
machine Pinger {
    // State machine variable: stores the identity of the Ponger machine we'll communicate with
    var ponger: machine;

    // Define the initial state of the Pinger machine (marked with 'start' keyword)
    start state Init {
        // Entry action: runs when entering this state
        // Parameter 'p' receives the Ponger machine's identity
        entry (p: machine) {
            // Store the reference to the Ponger machine in our state variable
            ponger = p;
            // Transition to PingState to start sending ping messages
            goto PingState;
        }
    }

    // Define the PingState - this is where the machine stays while ping-ponging
    state PingState {
        // Entry action: runs when entering this state
        // Send a Ping event to the ponger machine, passing 'this' (the Pinger's identity) as the payload
        entry { send ponger, Ping, this; }
        // Event handler: when we receive a Pong event, transition back to PingState
        // This creates a loop: enter PingState -> send Ping -> receive Pong -> stay in PingState
        on Pong goto PingState;
    }
}

// Define the Ponger machine - this machine responds to ping messages
machine Ponger {
    // Define the initial state of the Ponger machine (marked with 'start' keyword)
    start state Wait {
        // Event handler: when we receive a Ping event, execute the 'do' action
        // The payload of the Ping event (the Pinger's identity) is captured in the 'pinger' parameter
        on Ping do (pinger: machine) {
            // Send a Pong event back to the machine that sent us the Ping
            send pinger, Pong;
        }
    }
}
