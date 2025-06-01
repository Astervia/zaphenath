# Testing Overview

Zaphenath includes a full suite of tests written with the Foundry framework (`forge-std`). These tests ensure the core behaviors of the system are enforced reliably across key lifecycle operations, access control, and timeout logic.

## ✅ Test File

- `test/Zaphenath.t.sol`

This file contains unit tests for:

- Key creation and uniqueness
- Ping mechanics
- Read conditions before and after timeout
- Custodian assignments and role enforcement
- Key updates and deletions

## 🔧 How to Run Tests

```bash
forge test -vv
```

- `-vv` enables verbose output including `console.log` traces.
- All tests are self-contained and simulate user addresses using `vm.prank()`.

## 🔍 Example Assertion

```solidity
assertEq(data, bytes("Soli Deo Gloria"));
```

Used to verify key content and state mutations.

## 🧪 Test Helpers

- `vm.warp()` to simulate time passing
- `vm.expectRevert()` to test failure conditions
- `vm.prank(address)` to impersonate users

## 🔁 Suggested Additions

- Fuzz tests for timeout edge cases
- Property tests for role escalations and demotions
- Integration tests across multiple keys and users

---

➡️ Learn about [Writing Custom Tests](writing-tests.md)
