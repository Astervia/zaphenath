# Deployment

This guide walks you through deploying the Zaphenath contract using Foundry scripts.

## Deploying Locally with Anvil

### 1. Start a local testnet

```bash
anvil
```

This launches a local Ethereum node with test accounts.

### 2. Run the deploy script

In a separate terminal:

```bash
forge script script/Zaphenath.s.sol \
  --broadcast \
  --rpc-url http://localhost:8545
```

You should see output showing the deployed contract address.

## Deploying to a Public Testnet (e.g., Sepolia)

### 1. Set environment variables

Export your private key and RPC URL. For safety, use `.env` in real projects.

```bash
export PRIVATE_KEY=your_private_key
export RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
```

### 2. Deploy

```bash
forge script script/Zaphenath.s.sol \
  --broadcast \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY
```

## Deployment Output

After deployment, Foundry logs the contract address. Save it for contract interactions.

## Troubleshooting

- **Missing console logs?** Ensure you're using `console.log` from `forge-std`.
- **Contract not found?** Verify your paths in `import` and `foundry.toml`.
- **Network errors?** Make sure RPC URLs and keys are correctly set.

---

➡️ Next: [Zaphenath Contract Details](../contracts/zaphenath.md)
