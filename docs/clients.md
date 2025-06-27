# 🧩 Clients Overview

This page lists the available client implementations for interacting with the Zaphenath smart contract. These clients offer different ways to integrate with the protocol, including command-line tools and UI components.

## 🦀 Rust CLI Client

The Rust CLI client allows developers, power users, and backend scripts to interact directly with the Zaphenath smart contract from the terminal.

### 📦 Repository

> [github.com/Astervia/zaphenath-cli-client](https://github.com/Astervia/zaphenath-cli-client)

### 🚀 Features

- Create, update, delete, and read keys on-chain
- Assign and manage custodians
- Ping keys to keep them alive
- Configurable local profiles
- Support for multiple networks (e.g. mainnet, Sepolia, Anvil)
- Background daemon for automated key pings

### 🛠 Installation

Ensure you have [Rust](https://www.rust-lang.org/tools/install) and `cargo` installed.

To install globally, you must clone the repository and install using `cargo`:

```bash
git clone https://github.com/Astervia/zaphenath-cli-client.git
cd zaphenath-cli-client
cargo install --path .
```

### ▶️ Usage

Run `zaph` to see available commands:

```bash
zaph --help
```

Example:

```bash
zaph contract create-key \
  --key-id my-will \
  --data 0x... \
  --timeout 3600 \
  --readable-before-timeout \
  --contract-address 0x... \
  --private-key-path ~/.zaph/id.key
```

### 🧪 Daemon Mode

The CLI also supports a background daemon:

```bash
zaph daemon
```

This will periodically ping registered keys to keep them private.

## 📱 Upcoming Clients

- **Mobile Client** (in development): Touch-friendly interface for creating, reading, and managing keys, with a mobile daemon available
- **Web Dashboard** (planned): Browser interface for viewing key activity and status
