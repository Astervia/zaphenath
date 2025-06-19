# Key Lifecycle

This guide outlines the full lifecycle of a key in the Zaphenath system—from creation to deletion, including access control and timeout transitions.

## 🪪 1. Key Creation

Keys are created using `createKey()` by the owner.

```solidity
zaph.createKey(keyId, data, timeout);
```

- `keyId`: A unique identifier per owner (hashed internally)
- `data`: Encrypted or confidential content
- `timeout`: Seconds until public access if no ping

## 👁 2. Key Access

Reading a key requires:

- Caller to be `Reader`, `Writer`, or `Owner`
- Timeout to have passed

```solidity
zaph.readKey(keyId, owner);
```

> [!WARNING] > `readKey` is a `view` function. That means users can declare
> identity by providing _addresses_ instead of _signing transactions_.
> After your timeout expires, any user that knows a `Reader`
> address can access your content. You should use on-chain and
> off-chain strategies to guarantee your privacy.

## 🔁 3. Maintaining Privacy (Ping)

The owner or a custodian (if allowed) must call `ping()` periodically to reset the `lastPing` timestamp:

```solidity
zaph.ping(keyId, owner);
```

Failing to ping will result in data becoming readable after the timeout period.

## 🧑‍🤝‍🧑 4. Managing Custodians

The owner can assign or remove custodians:

```solidity
zaph.setCustodian(keyId, owner, user, Role.Writer, true);
zaph.removeCustodian(keyId, owner, user);
```

## ✏️ 5. Updating Keys

Users with `Writer` or `Owner` roles can update:

```solidity
zaph.updateKey(keyId, owner, newData, newTimeout);
```

## 🗑 6. Deleting Keys

Writers and Owners can delete the key permanently:

```solidity
zaph.deleteKey(keyId, owner);
```

## 🔒 7. Access Reverts to Public (Post-Timeout)

Once timeout expires and no ping has occurred, any custodian with `Reader` or higher access can read the key.

---

➡️ See [Examples](examples.md) for practical workflows
