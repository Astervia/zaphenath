# Usage Examples

This page provides practical examples for using the Zaphenath contract in real scenarios, focusing on core operations such as key creation, access control, and timeout behavior.

---

## 🧪 Create a Key

```solidity
vm.prank(rachel);
zaph.createKey("0xabc123", bytes("Top Secret"), 3 days, true);
```

Rachel creates a key that will become public in 3 days unless she pings.

---

## 👁 Owner Reads Before Timeout

```solidity
vm.prank(rachel);
bytes memory data = zaph.readKey("0xabc123", rachel);
```

Since `readableBeforeTimeout = true`, Rachel can read it before timeout.

---

## 🔒 Reader Can't Read Before Timeout

```solidity
vm.prank(rachel);
zaph.setCustodian("0xabc123", rachel, jacob, Role.Reader, false);

vm.prank(jacob);
vm.expectRevert("Insufficient role");
zaph.readKey("0xabc123", rachel);
```

Jacob is a Reader, but can't read before the timeout expires.

---

## ⌛ Read After Timeout

```solidity
vm.warp(block.timestamp + 4 days);

vm.prank(jacob);
bytes memory data = zaph.readKey("0xabc123", rachel);
```

After the timeout, Jacob can read the key.

---

## 🔁 Custodian Pings

```solidity
vm.prank(rachel);
zaph.setCustodian("0xabc123", rachel, jacob, Role.Writer, true);

vm.prank(jacob);
zaph.ping("0xabc123", rachel);
```

Jacob keeps the data private by resetting the timeout.

---

## 🗑 Delete Key

```solidity
vm.prank(rachel);
zaph.deleteKey("0xabc123", rachel);
```

Key is removed permanently.

---

➡️ Next: [Test Coverage](../testing/overview.md)
