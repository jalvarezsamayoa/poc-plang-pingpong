// Test machine to verify the existence and basic behavior of LossyNetwork
machine TestNetwork {
    start state Init {
        entry {
            var network: machine;
            // This should fail to compile because LossyNetwork is not yet defined
            network = new LossyNetwork();
        }
    }
}
