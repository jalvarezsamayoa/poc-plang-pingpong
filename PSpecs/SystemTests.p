// System test machines that initialize the test
// The 'Main' machine is the entry point for simulation and model checking

machine Main {
    // The 'start' keyword indicates this is the machine's initial state
    start state Init {
        // The 'entry' block is executed immediately when the state is entered
        entry {
            // Variables to store references to machine instances
            // In P, everything is a 'machine' reference
            var ponger: machine;
            var pinger: machine;

            // 'new' creates a new instance of a machine
            // Here we instantiate the Ponger machine first
            ponger = new Ponger();

            // Then we instantiate the Pinger machine, passing the ponger reference
            // This invokes the 'entry' action of Pinger's initial state with the ponger parameter
            pinger = new Pinger(ponger);
        }
    }
}

// New test case for the network
test NetworkCheck [main = TestNetwork]: {
    TestNetwork,
    LossyNetwork
};
