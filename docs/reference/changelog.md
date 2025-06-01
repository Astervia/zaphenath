# 🗒️ Changelog

All notable changes to **Zaphenath** will be documented in this file following
[Keep a Changelog](https://keepachangelog.com/) conventions and SemVer.

---

## [v0.1.0] – 2025‑06‑01

### Added

- **Initial release** of the full contract system.
- **Zaphenath.sol** – Core contract for secure, timeout-gated key storage

  - Per-owner key isolation using hashed identifiers
  - Role-based access control (`Owner`, `Writer`, `Reader`, `None`)
  - Ping-based inactivity tracking to unlock data
  - Per-key custodian delegation with `canPing` flag
  - `readableBeforeTimeout` toggle for controlled visibility

- **KeyData.sol** – Struct for key metadata and custodian mapping
- **Role.sol** – Enum for RBAC enforcement
- **Custodian.sol** – Custodian role wrapper

- **Full test suite** using `forge-std`

  - Role escalation & timeout logic
  - Ping behavior and revert expectations
  - Read/write/delete permission matrix

- **Deployment script** with `console.log` support
- **MkDocs documentation**
  - Full developer & usage guides
  - Support & consulting plans
  - Reference examples and lifecycle breakdown

### Infrastructure

- Compatible with **Foundry** stack (Forge, Anvil)
- Modular contract layout in `/src`
- Testing in `/test`, scripts in `/script`
- Docs build with `mkdocs-material`

### Documentation

- Docs hosted at [zaphenath.astervia.tech](https://zaphenath.astervia.tech)
- Includes lifecycle, roles, timeout explanation, and usage examples
- Consulting and donation plans available under `support/`

### Breaking Changes

_N/A – initial release._

### Known Issues

- Custodian mappings are not enumerable on-chain due to Solidity limitations
- Key metadata (`KeyData`) uses internal mappings and cannot be returned directly
- Contract assumes accurate timestamp behavior (subject to miner control on public nets)

---

**Source available on [GitHub](https://github.com/Astervia/zaphenath)**. Contributions welcome!
