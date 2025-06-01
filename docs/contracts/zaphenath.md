# Zaphenath Contract

The `Zaphenath` contract is the core of the system. It enables users to securely store and manage keys with timeout-based privacy and delegated access controls.

## 📘 Overview

Each key in Zaphenath is:

- Owned by a specific address
- Identified by a `bytes32 keyId`
- Associated with encrypted `data`
- Configured with a `timeout` and a `readableBeforeTimeout` flag

Data becomes readable after the timeout has passed unless `ping()` is called.

## 🔐 Key Components

### State

```solidity
mapping(bytes32 => KeyData) private keys;
```

Keys are internally identified by `keccak256(abi.encodePacked(owner, keyId))` to ensure per-owner uniqueness.

### Events

- `KeyCreated(bytes32 keyId, address owner)`
- `KeyDeleted(bytes32 keyId)`
- `KeyUpdated(bytes32 keyId)`
- `Pinged(bytes32 keyId, uint256 timestamp)`
- `CustodianUpdated(bytes32 keyId, address user, Role role, bool canPing)`

### Modifiers

- `onlyOwner(keyId, owner)`
- `onlyRoleOrAbove(keyId, owner, minimumRole)`
- `keyExists(keyId, owner)`

### Core Functions

#### `createKey(...)`

Creates a key with an initial data payload and timeout. Only one key per `keyId` per owner.

#### `readKey(...)`

Allows access based on:

- Role of the caller
- Whether timeout has expired
- If data is readable before timeout

#### `ping(...)`

Refreshes the last activity timestamp. Prevents timeout from triggering.

#### `updateKey(...)`

Allows Writers and Owners to update key metadata and data.

#### `deleteKey(...)`

Removes the key. Only Writer or Owner can perform this action.

#### `setCustodian(...)` / `removeCustodian(...)`

Assign or revoke roles and ping permission to external addresses.

## 🧠 Design Considerations

- `Custodian` mappings are stored within each `KeyData`, allowing per-key delegation.
- Role escalation is strictly enforced via `onlyRoleOrAbove()`.
- All key-related operations are scoped per `(owner, keyId)` pair.

## 🧪 Recommended Tests

- Owner creates key and reads it
- Reader cannot read before timeout
- Reader reads after timeout
- Ping resets timeout
- Custodians with and without ping permission

---

➡️ Learn about [Role Enum](role.md)
