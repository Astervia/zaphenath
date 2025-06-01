# ⛽ Gas & Denial of Service (DoS)

Zaphenath's contract design avoids iteration over dynamic data structures, but it's still subject to gas-related denial-of-service vectors if used carelessly or maliciously. This document explains how to avoid state bloat, excessive writes, and high-cost reads.

## 🚨 Common DoS Risks in Solidity

| Vector                       | Description                                                       |
| ---------------------------- | ----------------------------------------------------------------- |
| Storage Bloat                | Unbounded storage makes writes more expensive over time           |
| Looping Over Maps            | Not possible in Solidity; can’t iterate over custodians           |
| Recursive Calls / Reentrancy | Zaphenath avoids this entirely (no external contract calls)       |
| Expensive Reads              | Large key data or deep access nesting may exceed block gas limits |
| Ping Flooding                | Repeated `ping()` calls consume storage writes & log gas          |

## ⚙️ Zaphenath Design Decisions

### 1. Stateless Loops

- No iteration over custodians
- All access is direct via mapping lookups

### 2. Per-Key Isolation

- Each key is accessed by `bytes32 fullKey = keccak256(owner, keyId)`
- This minimizes shared state contention

### 3. Controlled Ping Behavior

- `ping()` only updates a single timestamp
- Emits a log but does not mutate deep structures

### 4. Opaque `bytes` Data Field

- Allows users to optimize their own data size
- Contract doesn’t validate or parse the content

## 🔒 Safe Usage Guidelines

| Action                 | Recommendation                                                      |
| ---------------------- | ------------------------------------------------------------------- |
| Storing large payloads | Keep content off-chain (e.g. IPFS), store only reference in `bytes` |
| High-frequency pings   | Use rate limits via UI or scripts, no more than 1/hour recommended  |
| Deleting keys          | Clean up unused keys to free storage                                |
| Event overuse          | Monitor logs if automating roles or pings                           |

## 🛡 Future Improvements

- Rate-limiting for pings (optional module)
- Batch read utility (off-chain) to reduce frontend queries
- Circuit-breaker config to auto-disable misused keys

---

➡️ Next: [Smart Contract Best Practices](best-practices.md)
