# 🔐 Role Abuse & Privilege Escalation

Role-based access control is core to Zaphenath’s architecture. The `Role` enum (None, Reader, Writer, Owner) defines what each address can do for a specific key. Improper assignment or unchecked escalation can compromise the protocol’s security.

## 🔁 Role Definitions

| Role   | Access Level | Capabilities                                                                                        |
| ------ | ------------ | --------------------------------------------------------------------------------------------------- |
| None   | 0            | No access                                                                                           |
| Reader | 1            | Can read the key after timeout                                                                      |
| Writer | 2            | Can update key metadata and delete the key                                                          |
| Owner  | 3            | Full control including assigning roles, managing custodians and reading before timeout (if enabled) |

Each `KeyData` instance defines custodian roles using:

```solidity
mapping(address => Custodian)
```

Where a `Custodian` struct contains both `role` and `canPing`.

## 🧨 Attack Vector: Improper Role Assignment

### Scenario

An owner mistakenly sets a `Reader` as a `Writer`, or enables `readableBeforeTimeout` and sets a role too high.

### Impact

- Custodian gains ability to **delete** or **overwrite** key data.
- Confidential data becomes accessible **before timeout**.

## 🚧 Mitigations

### 1. Explicit Role Gates

Functions use the `onlyRoleOrAbove` modifier:

```solidity
require(uint8(callerRole) >= uint8(minimumRole), "Insufficient role");
```

This enforces strict access thresholds.

### 2. Public Events for Role Changes

All custodian assignments trigger:

```solidity
CustodianUpdated(keyId, user, role, canPing)
```

Allowing off-chain monitoring of escalations.

### 3. Minimal Default Permissions

When a key is created:

- No custodians are assigned.
- All access must be explicitly granted by the owner.

## ✅ Best Practices

| Recommendation                      | Reason                                   |
| ----------------------------------- | ---------------------------------------- |
| Start with `Role.Reader`            | Avoid accidental write/delete privileges |
| Use `canPing = false` unless needed | Prevent unintended ping interactions     |
| Revoke roles explicitly             | Use `removeCustodian()` when access ends |
| Monitor `CustodianUpdated` events   | Ensure no privilege creep occurs         |

## 🔭 Future Improvements

- UI-level simulation of role effects before confirmation
- Multi-sig confirmation for `Role.Writer` or `Owner` assignments
- Role expiration timestamps or time-bound roles

---

➡️ Next: [Gas & Denial of Service](dos.md)
