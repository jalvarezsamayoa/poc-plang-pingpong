// System test machines that initialize the test
// The 'Main' machine is the entry point for simulation and model checking

machine Main {
    start state Init {
        entry {
            var ponger: machine;
            var pinger: machine;
            var network: machine;

            ponger = new Ponger();
            network = new LossyNetwork();
            pinger = new Pinger(network);

            // Configure the network to mediate between pinger and ponger
            send network, Config, (p = pinger, po = ponger);
        }
    }
}

// Default system test with liveness monitor
test DefaultTest [main = Main]: assert LivenessMonitor in {
    Main,
    Pinger,
    Ponger,
    LossyNetwork
};

// New test case for the network
test NetworkCheck [main = TestNetwork]: {
    TestNetwork,
    LossyNetwork
};
