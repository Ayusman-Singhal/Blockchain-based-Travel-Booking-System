# Travel Booking System on Aptos

A decentralized travel booking platform built on the Aptos blockchain using the Move programming language. This project enables users to create, manage, and book flights and accommodations in a secure and transparent way.

## Features

- **Flight Management**
  - Create flight listings with details (departure/arrival cities, times, pricing)
  - Book available flights
  - Track flight capacity and bookings

- **Accommodation Management**
  - List accommodations with details (name, location, dates, pricing)
  - Book available rooms
  - Track accommodation capacity and bookings

## Project Structure

```
travel_booking/
├── .aptos/              # Aptos configuration files
├── build/               # Compiled artifacts
├── scripts/             # Helper scripts
├── sources/             # Move source code
│   ├── project.move     # Flight management module
│   ├── project01.move   # Accommodation management module
│   └── project03.move   # Main travel booking module
├── tests/               # Test files
└── Move.toml            # Project configuration
```

## Getting Started

### Prerequisites

- [Aptos CLI](https://aptos.dev/tools/aptos-cli/install-cli/)
- [Move Compiler](https://aptos.dev/tools/aptos-cli/use-cli/install-move-prover/)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd travel_booking
```

2. Compile the project:
```bash
aptos move compile
```

3. Run tests:
```bash
aptos move test
```

### Deployment

Deploy to the Aptos blockchain using:

```bash
aptos move publish
```

#### Successful Deployment

The project has been successfully deployed to the Aptos devnet:

- **Modules Deployed**:
  - 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::accommodations
  - 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::flights
  - 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::travel_booking

- **Transaction Details**:
  - Transaction hash: 0xb6f30fb48c6ecce66c5e3b67a605190c734016d1969bf9bade266e5f73933f49
  - Network: devnet
  - Explorer link: [View on Aptos Explorer](https://explorer.aptoslabs.com/txn/0xb6f30fb48c6ecce66c5e3b67a605190c734016d1969bf9bade266e5f73933f49?network=devnet)

## Usage

### Initialize the Travel Booking System

```bash
aptos move run --function-id 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::travel_booking::initialize
```

### Create a Flight

```bash
aptos move run --function-id 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::flights::create_flight \
  --args string:"New York" string:"London" u64:1679529600 u64:1000 u64:200
```

### Book a Flight

```bash
aptos move run --function-id 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::flights::book_flight \
  --args u64:<flight_id> u64:2
```

### Create an Accommodation

```bash
aptos move run --function-id 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::accommodations::create_accommodation \
  --args string:"Luxury Hotel" string:"Paris" u64:1679529600 u64:1679616000 u64:200 u64:50
```

### Book an Accommodation

```bash
aptos move run --function-id 03671792f8f385c96010cae32534b803cd3a5d69f1c888d20a2880a9a1357113::accommodations::book_accommodation \
  --args u64:<accommodation_id> u64:1
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 