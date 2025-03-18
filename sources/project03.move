module travel_booking::travel_booking {
    use std::signer;
    use travel_booking::flights;
    use travel_booking::accommodations;

    /// Errors
    const ENOT_AUTHORIZED: u64 = 1;

    /// Function to initialize the travel booking system
    public entry fun initialize(account: &signer) {
        // Only the module owner can initialize the system
        assert!(signer::address_of(account) == @travel_booking, ENOT_AUTHORIZED);
        
        // Initialize both modules
        flights::initialize(account);
        accommodations::initialize(account);
    }
} 