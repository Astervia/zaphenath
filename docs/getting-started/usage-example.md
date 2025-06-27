# 🧪 Usage Example: Local Test with Anvil

This guide walks you through a full example of using the Zaphenath CLI client in a local environment powered by [Anvil](https://book.getfoundry.sh/anvil/). You'll create a key, test timeout behavior, and see the daemon in action with the [CLI Client](https://github.com/Astervia/zaphenath-cli-client).

## ⚙️ 1. Start Anvil

Run Anvil with a fixed mnemonic and fast block time:

```bash
anvil --port 8545 \
    --mnemonic "test test test test test test test test test test test junk" \
    --block-time 1
```

## 📦 2. Deploy the Zaphenath Smart Contract

Export the default Anvil private key (auto-funded):

```bash
export TEST_PRIVKEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Clone the contract repo and deploy it:

```bash
git clone https://github.com/Astervia/zaphenat.git
cd zaphenat

forge script script/Zaphenath.s.sol \
  --broadcast \
  --private-key $TEST_PRIVKEY \
  --rpc-url http://localhost:8545
```

Extract the deployed contract address:

```bash
export CONTRACT_ADDRESS=$(jq -r \
  '.transactions[] | select(.contractName=="Zaphenath") | .contractAddress' \
  broadcast/Zaphenath.s.sol/31337/run-latest.json)
```

## 🔑 3. Save the Private Key (Optional)

To use with the CLI without re-passing it:

```bash
echo "$TEST_PRIVKEY" > ~/.zaphenathpkey
chmod 600 ~/.zaphenathpkey
```

## 🗂️ 4. Initialize the Local Configuration File

Zaphenath CLI uses a local config file to track keys, contract addresses, and network settings.

First, initialize the config:

```bash
zaph config init
```

Then, add your test key entry to the config:

```bash
zaph config add \
  --key-id testkey \
  --contract-address $CONTRACT_ADDRESS \
  --private-key-path ~/.zaphenathpkey \
  --network anvil \
  --rpc-url http://localhost:8545 \
  --timeout 10
```

Optional: view the config content to confirm:

```bash
zaph config view
```

## 🏗️ 5. Create a Key On-Chain (with Small Timeout)

```bash
zaph contract create-key \
  --key-id testkey \
  --data deadbeefcafebabe \
  --timeout 10 \
  --gas-buffer 1.2 \
  --contract-address $CONTRACT_ADDRESS \
  --private-key-path ~/.zaphenathpkey \
  --network anvil \
  --rpc-url http://localhost:8545 \
  -y
```

## 🔒 6. Try Reading Before Timeout (Should Fail)

```bash
zaph contract read-key \
  --key-id testkey
```

Expect an error:
`Data not available before timeout`

## ⏳ 7. Wait & Read After Timeout (Should Succeed)

Wait 10 seconds:

```bash
sleep 10
zaph contract read-key \
  --key-id testkey
```

Expected output:
`0xdeadbeefcafebabe`

## 🌀 8. Start the Daemon

```bash
zaph daemon run \
  --interval 5 \
  --gas-buffer 1.2 \
  -y
```

The daemon will keep the key "alive" by pinging it regularly.

## 🚫 9. Try Reading Again (Should Fail)

```bash
zaph contract read-key \
  --key-id testkey
```

Expected:
`Data not available before timeout`

## 🧯 10. Stop the Daemon

Use `Ctrl+C` to stop the daemon.

## ✅ 11. Wait & Read Again (Should Succeed)

Wait another 10 seconds:

```bash
sleep 10
zaph contract read-key \
  --key-id testkey
```

Expected:
`0xdeadbeefcafebabe`

## ✅ Summary

| Step | Action                   | Expected Outcome                   |
| ---- | ------------------------ | ---------------------------------- |
| 1    | Start Anvil              | Local testnet ready                |
| 2    | Deploy contract          | Contract deployed                  |
| 3    | Export key               | Used for TX signing                |
| 4    | Initialize config        | Config file and key registered     |
| 5    | Create key on-chain      | Key created with timeout           |
| 6    | Read immediately         | ❌ Fails — still within timeout    |
| 7    | Read after timeout       | ✅ Success                         |
| 8    | Start daemon             | Key is pinged                      |
| 9    | Read while daemon active | ❌ Fails — timeout keeps resetting |
| 10   | Stop daemon              | Timer begins again                 |
| 11   | Read after inactivity    | ✅ Success                         |
