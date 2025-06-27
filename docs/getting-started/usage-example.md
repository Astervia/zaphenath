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

## 🏗️ 4. Create a Key (with small timeout)

Create a test key with a 10-second timeout:

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

## 🔒 5. Try Reading Before Timeout (Should Fail)

```bash
zaph contract read-key \
  --key-id testkey
```

Expect an error with the message:
`Data not available before timeout`

## ⏳ 6. Wait & Read After Timeout (Should Succeed)

Wait 10 seconds and read:

```bash
sleep 10
zaph contract read-key \
  --key-id testkey
```

Expected:
`0xdeadbeefcafebabe`

## 🌀 7. Start the Daemon

```bash
zaph daemon run \
  --interval 5 \
  --gas-buffer 1.2 \
  -y
```

The daemon pings keys periodically to keep them private.

## 🚫 8. Try Reading Again (Should Fail)

```bash
zaph contract read-key \
  --key-id testkey
```

Still fails:
`Data not available before timeout`

The daemon reset the inactivity timer.

## 🧯 9. Stop the Daemon

Stop it with `Ctrl+C`.

## ✅ 10. Wait & Read Again (Should Succeed)

Wait another 10 seconds and read again:

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
| 4    | Create key               | Key registered on-chain            |
| 5    | Read immediately         | ❌ Fails — still within timeout    |
| 6    | Read after timeout       | ✅ Success                         |
| 7    | Start daemon             | Key is pinged                      |
| 8    | Read while daemon active | ❌ Fails — timeout keeps resetting |
| 9    | Stop daemon              | Timer begins again                 |
| 10   | Read after inactivity    | ✅ Success                         |
