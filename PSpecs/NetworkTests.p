// Test machine to verify the existence and basic behavior of LossyNetwork
machine TestNetwork {
    start state Init {
        entry {
            var network: machine;
            // Provide dummy machines (self) to satisfy initialization
            network = new LossyNetwork((p = this, po = this));
            // This should cause an unhandled event error in LossyNetwork
            // because it has no on Ping handler yet.
            send network, Ping, this;
        }
    }
}
