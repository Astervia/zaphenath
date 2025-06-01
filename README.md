# Zaphenath Smart Contract

**Zaphenath** is a smart contract system for secure key-value storage with inactivity-based conditional access. It supports role-based access control, data privacy before inactivity timeouts, and multi-user custodianship. Designed for sensitive data management, such as wills or internal company secrets.

## 🛠 Features

- Create, read, update, and delete encrypted key data.
- Privacy-aware access rules (readable before timeout or only after).
- Automatic data exposure after owner inactivity (ping-based).
- Fine-grained role control: `Owner`, `Writer`, `Reader`, `None`.
- Custodian system supports delegated read/write/ping permissions.

## 📦 Project Structure

```
.
├── src/
│   ├── Zaphenath.sol          # Main contract logic
│   ├── Role.sol               # Role enum
│   ├── Custodian.sol          # Custodian struct
│   └── KeyData.sol            # KeyData struct with mappings
├── test/
│   └── Zaphenath.t.sol        # Full test suite using Foundry
├── script/
│   └── Zaphenath.s.sol        # Deployment script
└── foundry.toml               # Foundry config
```

## 🚀 Deployment

### Prerequisites

Ensure [Foundry](https://book.getfoundry.sh/) is installed:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Deploy Locally with Anvil

Start a local node:

```bash
anvil
```

Then deploy:

```bash
forge script script/Zaphenath.s.sol --broadcast --rpc-url http://localhost:8545
```

### Deploy to Sepolia (or other testnet)

Set your private key and RPC in environment variables or `.env`:

```bash
export PRIVATE_KEY=<your_private_key>
export RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
```

Then run:

```bash
forge script script/Zaphenath.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

## 🧪 Running Tests

Run the test suite with verbose output:

```bash
forge test -vv
```

You'll see detailed logs thanks to `console.log` statements.

## 🔐 Roles

| Role   | Description                                                     |
| ------ | --------------------------------------------------------------- |
| Owner  | Full control, set custodians and read before timeout if allowed |
| Writer | Can update or delete the key                                    |
| Reader | Can read after timeout (or before, if allowed)                  |
| None   | No access                                                       |

Use `setCustodian()` and `removeCustodian()` to manage roles.

## ⏱ Ping-Based Timeout Logic

- Each key has a `timeout` (in seconds) and `lastPing` timestamp.
- When `block.timestamp - lastPing > timeout`, key data becomes available.
- `ping()` resets the timer, keeping data private.
- If `readableBeforeTimeout` is `true`, the **owner** can read it anytime.

## 📜 License

MIT License. See [`LICENSE`](LICENSE) file.
