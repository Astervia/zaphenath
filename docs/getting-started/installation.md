# Installation

This page guides you through setting up the Zaphenath project using the [Foundry](https://book.getfoundry.sh/) toolchain.

## Prerequisites

- [Git](https://git-scm.com/) installed
- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

- A modern Solidity-compatible code editor (e.g. VS Code with Solidity plugin)

## Clone the Repository

```bash
git clone https://github.com/Astervia/zaphenath.git
cd zaphenath
```

## Install Dependencies

Zaphenath uses `forge` to manage dependencies.

```bash
forge install
```

If external libraries are used in the future (e.g., OpenZeppelin), you can install them via:

```bash
forge install openzeppelin/openzeppelin-contracts
```

## Verify Installation

Run the tests to ensure everything is working:

```bash
forge test
```

You should see output confirming the test suite ran successfully.

---

➡️ Next: [Deployment Guide](deployment.md)
