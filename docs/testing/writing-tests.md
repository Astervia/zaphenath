# Writing Custom Tests

This guide helps you write additional tests for the Zaphenath contract using the Foundry testing framework.

## 🧰 Setup

Tests are located in the `test/` directory and follow this structure:

```solidity
contract ZaphenathTest is Test {
    Zaphenath public zaph;

    function setUp() public {
        zaph = new Zaphenath();
    }
}
```

Use `vm.prank()` to simulate calls from different addresses:

```solidity
vm.prank(rachel);
zaph.createKey(...);
```

## ✅ Common Tools

| Tool                | Description                         |
| ------------------- | ----------------------------------- |
| `vm.prank()`        | Simulate msg.sender                 |
| `vm.warp()`         | Simulate time passing               |
| `vm.expectRevert()` | Expect failure with specific reason |
| `console.log()`     | Debug inside tests                  |

## 🧪 Test Ideas

- 📤 A Writer tries to delete a key
- 🔐 A Reader tries to update a key (should fail)
- ⏱ A custodian pings just before timeout
- 🚫 Unauthorized user tries to assign custodian

## 🧩 Example: Prevent Non-Owner Ping Without Permission

```solidity
function testCustodianCannotPingIfNotAllowed() public {
    vm.prank(owner);
    zaph.setCustodian(keyId, owner, jacob, Role.Writer, false);

    vm.prank(jacob);
    vm.expectRevert("Not authorized to ping");
    zaph.ping(keyId, owner);
}
```

---

🧪 Don’t forget to run your tests with:

```bash
forge test -vv
```

➡️ Visit the [Support FAQ](../support/faq.md)
