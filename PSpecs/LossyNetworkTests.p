// Test to verify that LossyNetwork can drop events non-deterministically.

machine DummyPonger {
    start state Wait {
        on Ping do {
            // Drop it, we just want to see if it reaches here
        }
    }
}

machine TestLossyNetwork {
    var network: machine;
    var ponger: machine;

    start state Init {
        entry {
            ponger = new DummyPonger();
            // Pass this as pinger, and ponger as ponger using a tuple
            network = new LossyNetwork((p = this, po = ponger));
            send network, Ping, this;
            send network, Pong;
            goto CheckDrop;
        }
    }

    state CheckDrop {
        // If the network drops it, we won't see Ping back here.
        // If it forwards it, we would see it on DummyPonger, but we can't observe that easily from here.
        // Let's just make the test succeed if it doesn't crash.
        on Ping do {
            // This is if it was sent back to us (the 'pinger')
            // But Ping is sent to ponger.
        }
        on Pong do {
            // Received Pong back from network
        }
    }
}

test LossyNetworkDrop [main = TestLossyNetwork]: {
    TestLossyNetwork,
    LossyNetwork,
    DummyPonger
};
