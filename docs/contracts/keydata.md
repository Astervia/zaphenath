# KeyData Struct

The `KeyData` struct holds the full state of a single key in the Zaphenath contract. It encapsulates all metadata and access configurations for secure storage.

## 📘 Definition

```solidity
struct KeyData {
    address owner;
    bytes data;
    uint256 lastPing;
    uint256 timeout;
    mapping(address => Custodian) custodians;
    bool exists;
}
```

> ℹ️ The `KeyData` struct uses an internal mapping, so it cannot be returned or passed directly in external/public functions.

## 🔐 Fields

| Field        | Type                            | Description                                      |
| ------------ | ------------------------------- | ------------------------------------------------ |
| `owner`      | `address`                       | Owner of the key                                 |
| `data`       | `bytes`                         | Encrypted or opaque data payload                 |
| `lastPing`   | `uint256`                       | Timestamp of last `ping()`                       |
| `timeout`    | `uint256`                       | Number of seconds before data becomes accessible |
| `custodians` | `mapping(address => Custodian)` | Role and ping permission map for external users  |
| `exists`     | `bool`                          | Tracks if the key is initialized                 |

## 🧠 Design Considerations

- Uses nested mappings to support per-user access control.
- `exists` avoids accidental reads on uninitialized keys.

## 🧪 Testing Tips

- Validate default values upon key creation
- Verify access rules with various custodian combinations
- Ensure timeout enforcement and `ping()` logic are working

---

➡️ Proceed to [Using Roles and Permissions](../usage/roles.md)
