# Custodian Struct

The `Custodian` struct defines the access role and ping privileges of a user over a specific key. Each key maintains its own set of custodians in a `mapping(address => Custodian)`.

## 📘 Definition

```solidity
struct Custodian {
    Role role;
    bool canPing;
}
```

## 🔐 Fields

| Field     | Type   | Description                                        |
| --------- | ------ | -------------------------------------------------- |
| `role`    | `Role` | The role assigned to the user (None, Reader, etc.) |
| `canPing` | `bool` | Whether the custodian is allowed to send `ping()`  |

## 📂 Context

Each `KeyData` instance includes a mapping:

```solidity
mapping(address => Custodian) custodians;
```

This allows each key to define a custom access policy for multiple users.

## 🛠 Use Cases

- Grant read-only access to a trusted contact after timeout.
- Allow a co-worker to refresh a ping timer on your behalf.
- Revoke permissions dynamically using `removeCustodian()`.

## 🧪 Testing Tips

- Assign and read back custodian roles and ping flags
- Attempt unauthorized pings and confirm they revert
- Ensure only Owners can assign/remove custodians

## 🔄 Related Functions

- `setCustodian(...)`
- `removeCustodian(...)`
- `ping(...)`
- `readKey(...)`

---

➡️ Next: [KeyData Struct](keydata.md)
