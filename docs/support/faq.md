# ❓ Frequently Asked Questions (FAQ)

## 🧩 What is Zaphenath?

Zaphenath is a smart contract system that locks data until a user becomes inactive. It’s designed for wills, fail-safes, and privacy-bound disclosures.

---

## 🛠 Do I need to use a frontend?

No, you can interact directly using Foundry, Ethers.js, or other on-chain tools. However, a frontend improves usability for non-technical users.

---

## ⏳ How does the timeout system work?

Each key has a `lastPing` and `timeout`. If `block.timestamp - lastPing > timeout`, data becomes readable to authorized users.

---

## 🧪 Can I test locally?

Yes! Use Anvil to simulate a testnet and `forge test` to run unit tests. See the [Testing Overview](../testing/overview.md) for details.

---

## 🔁 Can custodians be changed?

Yes, owners can add, update, or remove custodians dynamically using `setCustodian()` and `removeCustodian()`.

---

## 🔐 Who can read the data?

Only the owner (before timeout, if allowed) and authorized custodians (after timeout) with `Reader` or `Writer` roles.

---

## 🧑‍💻 Is this production-ready?

The code is well-tested but should be audited before mainnet use in high-stakes environments. We offer consulting for integration and audit prep.

---

## 💸 How do I support the project?

Check the [Support Plans](plans.md) and consider donating via Bitcoin or Lightning. All funds help sustain open-source development.

---

## 📬 How do I get in touch?

Email **[zaphenath@astervia.tech](mailto:zaphenath@astervia.tech)** — whether it’s a bug report, partnership idea, or consulting request, we’re here to help.
