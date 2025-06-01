# Ping Mechanism

The `ping()` function is a core feature of the Zaphenath contract. It keeps data private by updating the `lastPing` timestamp and thereby delaying the timeout.

## 🧭 Purpose

Zaphenath allows data to be accessed only after the owner has been inactive for a certain period. This inactivity is measured as:

```solidity
block.timestamp - lastPing > timeout
```

By calling `ping()`, the owner or an authorized custodian can reset this timer.

## 🔁 Function Signature

```solidity
function ping(bytes32 keyId, address owner) external;
```

## ✅ Who Can Ping?

- **Owner**: Always allowed
- **Custodians**: Only if `canPing` was set to `true` by the owner

## 🛠 Use Cases

- Keep private data hidden as long as the user is "active"
- Allow a trusted custodian to maintain activity on behalf of a user
- Ensure data is only released if truly inactive or incapacitated

## ⚠️ Behavior

- If a user fails to call `ping()` and `timeout` expires, data becomes readable by Readers and Writers
- Repeated `ping()` calls extend the private window indefinitely

## 🧪 Testing Scenarios

- Owner calls `ping()` → should update `lastPing`
- Custodian without ping permission → call reverts
- Custodian with ping permission → call succeeds
- No `ping()` and time advances → `readKey()` becomes accessible

---

➡️ Continue to [Key Lifecycle](key-lifecycle.md)
