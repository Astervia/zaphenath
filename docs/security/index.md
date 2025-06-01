# 🔐 Security Overview

Zaphenath is designed with high-stakes scenarios in mind—contexts where data should only become accessible if specific liveness signals (pings) are absent for a defined duration. This design makes the security surface both critical and nuanced.

This section of the documentation addresses potential threats, design trade-offs, and safe deployment practices for maintaining trust in Zaphenath's conditional access guarantees.

## 🧭 Threat Model

Zaphenath assumes a semi-trusted environment with the following properties:

- **Honest majority** of block producers (for time-based enforcement)
- **Non-malicious key owners and custodians** (outside role privilege scope)
- **Public chain visibility** (i.e., events and storage can be monitored by anyone)

The protocol does _not_ rely on external oracles, off-chain cron jobs, or scheduled transactions.

## 🧨 Key Threats Addressed

- **Time Oracle Manipulation**  
  Block producers can manipulate `block.timestamp`. Zaphenath enforces safe assumptions and minimum timeout intervals to mitigate this.

- **Privilege Escalation via Role Abuse**  
  Improper use of `setCustodian()` could accidentally expose data. Role checks and public logs serve as verification points.

- **Gas-Based Denial of Service (DoS)**  
  Storage expansion, frequent pings, or malicious keys could exhaust gas. The design minimizes state complexity and avoids loops over dynamic mappings.

- **Early Disclosure via Misconfiguration**  
  A careless setting of `readableBeforeTimeout = true` could leak data. This flag must be carefully audited during key creation.

## 🔐 Defense-in-Depth

| Layer       | Mitigation Strategy                                  |
| ----------- | ---------------------------------------------------- |
| Time        | Enforced minimum timeout, L1 time assumptions        |
| Roles       | Enum-based access, hard-coded privilege checks       |
| Custodians  | Explicit mapping per key, revocable                  |
| Readability | Boolean gate before timeout, enforced only for owner |
| Ping        | Timestamp validation + delegation control            |

## 🚧 Developer Responsibilities

Smart contracts cannot protect users from all misconfigurations. Developers integrating Zaphenath should:

- Validate all timeout durations are non-trivial (e.g., ≥ 1 day)
- Default to `readableBeforeTimeout = false` unless explicitly required
- Monitor on-chain events to track misuse or outdated configurations
- Write access policies and ping routines that are externally observable

---

➡️ Next: [Time Oracle Desync Attack](time-oracle.md)
