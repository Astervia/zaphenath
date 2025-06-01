# 🕒 Time Oracle Desynchronization Attack

Zaphenath uses `block.timestamp` to enforce inactivity timeouts. While this is common in Solidity contracts, it introduces a subtle but important class of risk: **timestamp manipulation by block producers**.

## ⚠️ The Risk

Validators or miners may slightly adjust `block.timestamp` within a protocol-defined drift range (typically ±15 seconds). This means:

- A **malicious validator** could slightly accelerate block time to trigger a timeout earlier than expected.
- Or they could **delay timeout execution**, giving a custodian less time to read the key.

While these shifts are small, their **impact scales** with:

- Short timeout configurations (e.g., under 1 hour)
- Misconfigured `readableBeforeTimeout` access rules

## 🔒 Mitigations in Zaphenath

### 1. Enforced Timeout Thresholds

Users are expected to set **timeouts of at least 1 day**, making manipulation by ±15s negligible.

### 2. Ping Enforcement

Pings reset the timeout timer and are **logged on-chain**, providing evidence of liveness.

### 3. No Timestamp Comparisons Between Blocks

The contract only compares `block.timestamp` against `lastPing`, avoiding logic that relies on **absolute time ranges**.

### 4. No Scheduled Callbacks or Automation

Zaphenath doesn’t use cron-like scheduling. Every action is explicitly triggered by user or custodian calls, reducing timing dependencies.

## ✅ Safe Usage Guidelines

| Situation                     | Recommendation                             |
| ----------------------------- | ------------------------------------------ |
| Timeout < 1 hour              | Not recommended                            |
| Timeout ≥ 1 day               | Safe for most use cases                    |
| Critical secrets (e.g. wills) | Use 7–30 days timeout with custodial pings |
| Time-sensitive access         | Monitor blockchain time closely            |

---

## 🛠 Suggested Enhancements (Future Work)

- **Layer-2 timestamp validation**: Accept only L1 timestamps in rollup contexts.
- **Cross-chain oracle integration**: To validate that a ping came after a real-world time threshold.
- **zkPing**: Off-chain proofs of liveness, verified on-chain without `block.timestamp`.

---

➡️ Next: [Role Abuse & Privilege Escalation](roles.md)
