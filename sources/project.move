module travel_booking::flights {
    use std::signer;
    use std::string::String;
    use aptos_framework::account;
    use aptos_framework::event;
    use aptos_framework::timestamp;

    /// Errors
    const EINVALID_FLIGHT_ID: u64 = 1;
    const EINVALID_PRICE: u64 = 2;
    const EINVALID_CAPACITY: u64 = 3;
    const EINVALID_DEPARTURE_TIME: u64 = 4;
    const EINSUFFICIENT_CAPACITY: u64 = 5;
    const EINVALID_OPERATOR: u64 = 6;

    /// Structs
    struct Flight has key, copy {
        id: u64,
        operator: address,
        departure_city: String,
        arrival_city: String,
        departure_time: u64,
        price: u64,
        capacity: u64,
        booked_seats: u64,
    }

    struct FlightEvents has key {
        flight_created_events: event::EventHandle<FlightCreatedEvent>,
        flight_booked_events: event::EventHandle<FlightBookedEvent>,
    }

    struct FlightCreatedEvent has drop, store {
        flight_id: u64,
        operator: address,
        departure_city: String,
        arrival_city: String,
        departure_time: u64,
        price: u64,
        capacity: u64,
    }

    struct FlightBookedEvent has drop, store {
        flight_id: u64,
        passenger: address,
        seats: u64,
    }

    /// Functions
    public fun initialize(account: &signer) {
        move_to(account, FlightEvents {
            flight_created_events: account::new_event_handle<FlightCreatedEvent>(account),
            flight_booked_events: account::new_event_handle<FlightBookedEvent>(account),
        });
    }

    public entry fun create_flight(
        operator: &signer,
        departure_city: String,
        arrival_city: String,
        departure_time: u64,
        price: u64,
        capacity: u64,
    ) acquires FlightEvents {
        let operator_addr = signer::address_of(operator);
        let flight_id = timestamp::now_microseconds();
        
        assert!(price > 0, EINVALID_PRICE);
        assert!(capacity > 0, EINVALID_CAPACITY);
        assert!(departure_time > timestamp::now_seconds(), EINVALID_DEPARTURE_TIME);

        let flight = Flight {
            id: flight_id,
            operator: operator_addr,
            departure_city,
            arrival_city,
            departure_time,
            price,
            capacity,
            booked_seats: 0,
        };

        move_to(operator, flight);

        let events = borrow_global_mut<FlightEvents>(@travel_booking);
        event::emit_event(
            &mut events.flight_created_events,
            FlightCreatedEvent {
                flight_id,
                operator: operator_addr,
                departure_city,
                arrival_city,
                departure_time,
                price,
                capacity,
            },
        );
    }

    public entry fun book_flight(
        passenger: &signer,
        flight_id: u64,
        seats: u64,
    ) acquires FlightEvents, Flight {
        let passenger_addr = signer::address_of(passenger);
        let flight = borrow_global_mut<Flight>(@travel_booking);
        
        assert!(flight.id == flight_id, EINVALID_FLIGHT_ID);
        assert!(flight.booked_seats + seats <= flight.capacity, EINSUFFICIENT_CAPACITY);

        flight.booked_seats = flight.booked_seats + seats;

        let events = borrow_global_mut<FlightEvents>(@travel_booking);
        event::emit_event(
            &mut events.flight_booked_events,
            FlightBookedEvent {
                flight_id,
                passenger: passenger_addr,
                seats,
            },
        );
    }

    public fun get_flight(flight_id: u64): Flight acquires Flight {
        let flight = borrow_global<Flight>(@travel_booking);
        assert!(flight.id == flight_id, EINVALID_FLIGHT_ID);
        *flight
    }
} 