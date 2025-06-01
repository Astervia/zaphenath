# ✅ Smart Contract Best Practices

Zaphenath is designed with minimalism, modularity, and auditability in mind. This page outlines best practices for writing, auditing, and integrating contracts similar to Zaphenath in production environments.

## 🔒 Code Structure Guidelines

- **Use explicit access control** — Every mutating function is guarded by `onlyRoleOrAbove()`.
- **Avoid nested mappings inside structs** — Keep data layout readable and storage-efficient.
- **Immutable logic flow** — Avoid external calls, unbounded loops, or delegatecall.
- **Event coverage** — Emit events on all mutating actions (create, update, delete, assign).

## 🧪 Testing Strategy

| Layer           | Tool              | Purpose                                   |
| --------------- | ----------------- | ----------------------------------------- |
| Unit Tests      | Foundry (`forge`) | Validate isolated contract behavior       |
| Integration     | Foundry + scripts | End-to-end flow across roles and timeouts |
| Fuzzing         | Foundry           | Randomized role/path combinations         |
| Time Simulation | `vm.warp()`       | Timeout verification                      |
| Revert Checks   | `expectRevert()`  | Ensure security fails when expected       |

### Suggested Coverage

- Ping behavior & logging
- Role enforcement and misassignment
- Timeout boundary enforcement
- Unauthorized access attempts

## 🔍 Audit Considerations

- **Storage collisions** — Ensure mappings are unique per key
- **Gas analysis** — Measure costs of `createKey`, `ping`, `readKey`, and `deleteKey`
- **Re-entrancy** — Not possible here, but audit hooks before adding external integrations
- **Invariant checks** — For example: a Writer must not access keys unless timeout passed

## ⚙️ Deployment & Upgrade Strategy

- **Immutable core** — Core Zaphenath contracts are designed for permanence
- **Proxy support (optional)** — Wrap in upgradeable proxy pattern only if needed
- **Scripted deployment** — Use `forge script` to avoid manual steps
- **Post-deploy tests** — Immediately test timeout logic after deployment

## 🔁 Operational Best Practices

- Monitor for excessive gas on specific keys
- Alert on `CustodianUpdated` or `readKey` usage
- Rotate test keys in staging environments
- Maintain off-chain documentation of key purposes and access levels

---

➡️ Next: [Deploying on Private Chains](private-blockchain.md)
