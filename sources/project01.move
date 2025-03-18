module travel_booking::accommodations {
    use std::signer;
    use std::string::String;
    use aptos_framework::account;
    use aptos_framework::event;
    use aptos_framework::timestamp;

    /// Errors
    const EINVALID_ACCOMMODATION_ID: u64 = 1;
    const EINVALID_PRICE: u64 = 2;
    const EINVALID_CAPACITY: u64 = 3;
    const EINVALID_CHECK_IN_DATE: u64 = 4;
    const EINSUFFICIENT_CAPACITY: u64 = 5;
    const EINVALID_OPERATOR: u64 = 6;

    /// Structs
    struct Accommodation has key, copy {
        id: u64,
        operator: address,
        name: String,
        location: String,
        check_in_date: u64,
        check_out_date: u64,
        price_per_night: u64,
        capacity: u64,
        booked_rooms: u64,
    }

    struct AccommodationEvents has key {
        accommodation_created_events: event::EventHandle<AccommodationCreatedEvent>,
        accommodation_booked_events: event::EventHandle<AccommodationBookedEvent>,
    }

    struct AccommodationCreatedEvent has drop, store {
        accommodation_id: u64,
        operator: address,
        name: String,
        location: String,
        check_in_date: u64,
        check_out_date: u64,
        price_per_night: u64,
        capacity: u64,
    }

    struct AccommodationBookedEvent has drop, store {
        accommodation_id: u64,
        guest: address,
        rooms: u64,
    }

    /// Functions
    public fun initialize(account: &signer) {
        move_to(account, AccommodationEvents {
            accommodation_created_events: account::new_event_handle<AccommodationCreatedEvent>(account),
            accommodation_booked_events: account::new_event_handle<AccommodationBookedEvent>(account),
        });
    }

    public entry fun create_accommodation(
        operator: &signer,
        name: String,
        location: String,
        check_in_date: u64,
        check_out_date: u64,
        price_per_night: u64,
        capacity: u64,
    ) acquires AccommodationEvents {
        let operator_addr = signer::address_of(operator);
        let accommodation_id = timestamp::now_microseconds();
        
        assert!(price_per_night > 0, EINVALID_PRICE);
        assert!(capacity > 0, EINVALID_CAPACITY);
        assert!(check_in_date > timestamp::now_seconds(), EINVALID_CHECK_IN_DATE);
        assert!(check_out_date > check_in_date, EINVALID_CHECK_IN_DATE);

        let accommodation = Accommodation {
            id: accommodation_id,
            operator: operator_addr,
            name,
            location,
            check_in_date,
            check_out_date,
            price_per_night,
            capacity,
            booked_rooms: 0,
        };

        move_to(operator, accommodation);

        let events = borrow_global_mut<AccommodationEvents>(@travel_booking);
        event::emit_event(
            &mut events.accommodation_created_events,
            AccommodationCreatedEvent {
                accommodation_id,
                operator: operator_addr,
                name,
                location,
                check_in_date,
                check_out_date,
                price_per_night,
                capacity,
            },
        );
    }

    public entry fun book_accommodation(
        guest: &signer,
        accommodation_id: u64,
        rooms: u64,
    ) acquires AccommodationEvents, Accommodation {
        let guest_addr = signer::address_of(guest);
        let accommodation = borrow_global_mut<Accommodation>(@travel_booking);
        
        assert!(accommodation.id == accommodation_id, EINVALID_ACCOMMODATION_ID);
        assert!(accommodation.booked_rooms + rooms <= accommodation.capacity, EINSUFFICIENT_CAPACITY);

        accommodation.booked_rooms = accommodation.booked_rooms + rooms;

        let events = borrow_global_mut<AccommodationEvents>(@travel_booking);
        event::emit_event(
            &mut events.accommodation_booked_events,
            AccommodationBookedEvent {
                accommodation_id,
                guest: guest_addr,
                rooms,
            },
        );
    }

    public fun get_accommodation(accommodation_id: u64): Accommodation acquires Accommodation {
        let accommodation = borrow_global<Accommodation>(@travel_booking);
        assert!(accommodation.id == accommodation_id, EINVALID_ACCOMMODATION_ID);
        *accommodation
    }
} 