# Roles and Permissions

Zaphenath uses a role-based access control system to manage interactions with keys. Each role defines the permissions a user has on a specific key, and these roles are enforced per `(keyId, owner)`.

## 🔑 Roles

| Role   | Access Level | Capabilities                                                                   |
| ------ | ------------ | ------------------------------------------------------------------------------ |
| None   | 0            | No access                                                                      |
| Reader | 1            | Can read the key after timeout or earlier if allowed                           |
| Writer | 2            | Can update key metadata and delete the key                                     |
| Owner  | 3            | Full control including assigning roles and reading before timeout (if enabled) |

## 👥 Custodians

Custodians are external addresses assigned a role and optional ping permission by the key owner.

```solidity
setCustodian(keyId, owner, user, Role.Writer, true);
```

This allows for:

- **Delegated Reading**: Readers can view key data after timeout
- **Collaborative Editing**: Writers can update/delete the key
- **Inactivity Protection**: Custodians with `canPing = true` can maintain the key’s private state

## ⚙️ Role Checks in Practice

Every function in the contract uses `onlyRoleOrAbove` to ensure the caller has sufficient privilege:

```solidity
require(uint8(callerRole) >= uint8(minimumRole), "Insufficient role");
```

> The owner always bypasses role checks and is considered highest priority.

## 🧪 Testing Scenarios

- Assign Jacob as Reader → he should read only after timeout
- Promote to Writer → he can now update/delete
- Demote to None → he loses all access
- Add ping permission → he can extend key privacy

---

➡️ Learn about the [Ping Mechanism](ping.md)
