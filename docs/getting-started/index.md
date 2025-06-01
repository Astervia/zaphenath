# Overview

**Zaphenath** is a Solidity-based smart contract system for securely storing and revealing sensitive information after user inactivity. It is designed for use cases like wills, confidential business data, and contingency disclosures.

This documentation site provides a complete guide to installing, deploying, and interacting with Zaphenath contracts, including technical specifications and code examples.

## Key Concepts

### 1. Key-Based Secure Storage

Each key is uniquely tied to an owner and contains encrypted data and metadata, such as timeout configuration and access rules.

### 2. Ping Mechanism for Inactivity

The contract uses a ping mechanism to detect user inactivity. If the user fails to send periodic "alive" pings, their data becomes readable by assigned custodians.

### 3. Role-Based Access Control

Zaphenath defines strict roles:

- **Owner**: Full permissions including management of other users.
- **Writer**: Can update and delete the key.
- **Reader**: Can read data (after timeout or if allowed earlier).
- **None**: No permissions.

### 4. Custodian Delegation

Users can assign custodians with specific roles and the ability to send pings on their behalf. This enables secure delegation of responsibilities.

### 5. Privacy Toggle

Data can optionally be made visible to the owner before the timeout expires using a `readableBeforeTimeout` setting.

## What You'll Learn

- How to deploy and test the Zaphenath contract
- How to create and manage keys
- How access and privacy settings work
- How to simulate inactivity and test timeout behavior

## Who This Is For

- Solidity developers building dApps with sensitive data handling
- Legaltech platforms handling digital wills
- Businesses needing conditional data exposure based on inactivity

---

➡️ Next: [Installation Guide](installation.md)
