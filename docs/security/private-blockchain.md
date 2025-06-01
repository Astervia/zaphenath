# 🏛 Deploying Zaphenath on a Private Blockchain

Zaphenath is designed to be EVM-compatible and works seamlessly on private or consortium chains. This is ideal for regulated environments such as law firms, financial institutions, or corporate governance where data flow and node participation are restricted.

## 🧩 Why Use a Private Chain?

| Benefit                   | Description                                                               |
| ------------------------- | ------------------------------------------------------------------------- |
| Controlled Participation  | Only approved nodes can read, write, and mine blocks                      |
| Custom Gas Policies       | Tailor gas costs or make interactions gasless for known actors            |
| Privacy & Confidentiality | Operate without exposing transactions or data logs to the public internet |
| Regulatory Alignment      | Match data access with internal compliance and legal processes            |

## ⚙️ Setup Requirements

### 1. Choose a Framework

- **Geth private network** (PoA or Clique)
- **Besu** with permissioned access
- **Ganache** for local testing

### 2. Adjust Genesis File

Set `chainId`, `blockTime`, and `difficulty` appropriately. For PoA, configure signers.

```json
"config": {
  "chainId": 1337,
  "clique": {
    "period": 5,
    "epoch": 30000
  }
}
```

### 3. Start Your Nodes

Run multiple instances to simulate consortium consensus:

```bash
geth --datadir node1 --networkid 1337 --http --http.port 8545 --nodiscover --mine --unlock "0x..." --password password.txt
```

### 4. Deploy Zaphenath

Use Foundry or Hardhat to deploy the contracts:

```bash
forge script script/Zaphenath.s.sol \
  --rpc-url http://localhost:8545 \
  --broadcast --private-key $PRIVATE_KEY
```

## 🔐 Customizations for Private Chains

- **Role registry contracts** to align with enterprise LDAP or user databases
- **Ping automation via scheduled bots** or off-chain backend integrations
- **Encrypted logs** or suppression of event emission for full confidentiality

## 🧪 Best Practices

| Practice                      | Why it matters                                      |
| ----------------------------- | --------------------------------------------------- |
| Use TLS and firewall rules    | Prevents external discovery or access               |
| Define onboarding/offboarding | Securely manage participant key material            |
| Mirror to IPFS or Arweave     | Enables off-chain archival with hash consistency    |
| Run time audits internally    | Catch timeout misconfigurations before key creation |

## 🌐 Example Use Cases

- Internal HR documents that unlock after employee departure
- Legal proof-of-life systems for will verification
- Private board meeting notes with delayed access to voting blocks

---

Zaphenath is EVM-neutral. If your infrastructure supports Solidity and block timestamps, it supports verifiable trust at rest.

> Need help deploying privately? [Contact us](mailto:zaphenath@astervia.tech).
