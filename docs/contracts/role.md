# Role Enum

The `Role` enum defines the access level a user has to a key within the Zaphenath system. It is a critical component of the role-based access control mechanism.

## 📘 Definition

```solidity
enum Role {
    None,
    Reader,
    Writer,
    Owner
}
```

## 🔐 Role Levels

Each role is associated with an increasing level of access:

| Role   | Value | Description                                    |
| ------ | ----- | ---------------------------------------------- |
| None   | 0     | No access                                      |
| Reader | 1     | Can read the key (after timeout or if allowed) |
| Writer | 2     | Can update and delete the key                  |
| Owner  | 3     | Full control including assigning custodians    |

Roles are evaluated using ordinal values, so `Role.Writer` is considered higher than `Role.Reader`, and so on.

## 🛡 Usage in Access Control

Access to sensitive operations is gated using the `onlyRoleOrAbove` modifier:

```solidity
modifier onlyRoleOrAbove(bytes32 keyId, address owner, Role minimumRole) {
    ...
    require(uint8(callerRole) >= uint8(minimumRole), "Insufficient role");
    _;
}
```

This enforces a minimum required role for specific functions.

## 🧪 Testing Tips

- Verify downgrade (e.g. from Writer to Reader) restricts access
- Confirm escalation from None to Reader grants read access post-timeout
- Ensure Owner always bypasses role checks automatically

---

➡️ Continue to [Custodian Struct](custodian.md)
