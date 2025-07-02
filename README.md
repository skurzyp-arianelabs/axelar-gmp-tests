# Axelar GMP Solidity Example

This project demonstrates General Message Passing (GMP) between EVM-compatible blockchains
using [Axelar Network](https://axelar.network/). It includes four contracts:

* `SourceIncrementer` and `DestCounter`: send and receive numeric counter values.
* `SourceMessenger` and `DestLogger`: send and receive string messages.

## Contracts

| Contract          | Role     | Purpose                                 |
|-------------------|----------|-----------------------------------------|
| SourceIncrementer | Sender   | Sends a `uint256` increment value       |
| DestCounter       | Receiver | Receives and applies the counter update |
| SourceMessenger   | Sender   | Sends a `string` message                |
| DestLogger        | Receiver | Receives and logs string messages       |

---

## 🔧 Prerequisites

Before deployment or interaction, build the contracts:

```shell
forge build
```

Ensure Foundry is installed and configured.

Export your private keys before deploying or sending messages:

```bash
export HEDERA_KEY=<your hedera private key>
export AVAX_KEY=<your avalanche chain private key>
export OP_KEY=<your optimism chain private key>
export BERA_KEY=<your berachian chain private key>
```

## 🚀 Deployment

### Chains configs

Consider the following testnet chains configs

| Chain           | hedera                                                            |
|-----------------|-------------------------------------------------------------------|
| Gateway Address | 0xe432150cce91c13a887f7D836923d5597adD8E31                        |
| Gas Service     | 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6                        |
| Multisig Prover | axelar1kleasry5ed73a8u4q6tdeu80hquy4nplfnrntx3n6agm2tcx40fssjk7gj |
| Voting Verifier | axelar1ce9rcvw8htpwukc048z9kqmyk5zz52d5a7zqn9xlq2pg0mxul9mqxlx2cq |
| RPC             | https://testnet.hashio.io/api                                     |

| Chain           | Avalanche                                  |
|-----------------|--------------------------------------------|
| Gateway Address | 0xC249632c2D40b9001FE907806902f63038B737Ab |
| Gas Service     | 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6 |
| ITS Address     | 0xB5FB4BE02232B1bBA4dC8f81dc24C26980dE9e3C |
| RPC             | https://api.avax-test.network/ext/bc/C/rpc |

| Chain           | optimism-sepolia                                                                        |
|-----------------|-----------------------------------------------------------------------------------------|
| Gateway Address | 0xe432150cce91c13a887f7D836923d5597adD8E31                                              |
| Gas Service     | 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6                                              |
| ITS Address     | 0xB5FB4BE02232B1bBA4dC8f81dc24C26980dE9e3C                                              |
| RPC             | https://optimism-sepolia.blockpi.network/v1/rpc/public (provided in docs - not working) |
| RPC (working)   | https://sepolia.optimism.io (working alternative)                                       |

| Chain           | berachain                                                         |
|-----------------|-------------------------------------------------------------------|
| Gateway Address | 0xe432150cce91c13a887f7D836923d5597adD8E31                        |
| Gas Service     | 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6                        |
| Multisig Prover | axelar1k483q898t5w0acqzxhdjlsmnpgcxxa49ye8m46757n8mtk70ugtsu927xw |
| RPC             | https://bepolia.rpc.berachain.com                                 |

> That information is based on the Official Axelar resources available
> at: https://testnet.axelarscan.io/resources/chains

### Deploy

Deploy contract pair (`counter` or `messenger`) to a chain:

```bash
CHAIN=hedera CONTRACT_PAIR=counter forge script script/UniversalDeploy.s.sol \
  --rpc-url https://testnet.hashio.io/api \
  --private-key $HEDERA_KEY \
  --broadcast
```

```bash
CHAIN=avalanche CONTRACT_PAIR=messenger forge script script/UniversalDeploy.s.sol \
  --rpc-url https://api.avax-test.network/ext/bc/C/rpc \
  --private-key $AVAX_KEY \
  --broadcast
```

* Supported `CHAIN` values: `hedera`, `avalanche`, `optimism`, `berachain`
* Supported `CONTRACT_PAIR` values: `counter`, `messenger`. (optional): defaults to `counter`

---

## ✈️ Example Flow: Hedera ➔ Avalanche (Counter)

1. ✅ **Deploy** `SourceIncrementer` on Hedera and `DestCounter` on Avalanche.
2. ✅ **Call** `increment("Avalanche", "<DestCounter>", value)` on Hedera.
3. ⏳ **Wait** for success and copy the tx hash.
4. 👀 **Trace** on [AxelarScan](https://testnet.axelarscan.io/).
5. ✔️ After delivery (\~<4min), **read** the counter on Avalanche using `cast call`.

Detailed scripts are presented in an [Interactions](#-interactions)
section.

---

## 🔄 Interactions

### Hedera → Avalanche (Counter)

| Contract Name     | Chain     | Address                                    |
|-------------------|-----------|--------------------------------------------|
| SourceIncrementer | Hedera    | 0x935C0e63024631f05eD4f46a16f252ed9cFdF3A4 |
| DestCounter       | Avalanche | 0x8d985F94ECF49D61327ebE96E80802EC75665cA0 |

#### ✉️ Send Increment

```bash
cast send 0x935C0e63024631f05eD4f46a16f252ed9cFdF3A4 \
  "increment(string,string,uint256)" "Avalanche" "0x8d985F94ECF49D61327ebE96E80802EC75665cA0" 1 \
  --rpc-url https://testnet.hashio.io/api \
  --private-key $HEDERA_KEY \
  --value 1ether
```

Example transaction:
[https://testnet.axelarscan.io/gmp/0xfaf9a3a0a1151565083840d63d2b095d6b58c578e24ff0ea77384c0527c96741](https://testnet.axelarscan.io/gmp/0xfaf9a3a0a1151565083840d63d2b095d6b58c578e24ff0ea77384c0527c96741) (
\~1m53s elapsed time)

#### 🔍 Check Result on Avalanche

```bash
cast call 0x8d985F94ECF49D61327ebE96E80802EC75665cA0 "count()" \
  --rpc-url https://api.avax-test.network/ext/bc/C/rpc
```

### Avalanche → Hedera (Messenger)

| Contract Name   | Chain     | Address                                    |
|-----------------|-----------|--------------------------------------------|
| SourceMessenger | Avalanche | 0xa607c2CA53874398Fb764Ccf422f85CEF6638639 |
| DestLogger      | Hedera    | 0x50F6F2f19E571DeA309bD43eC501A5383d6Ae069 |

#### ✉️ Send Message

```bash
cast send 0xa607c2CA53874398Fb764Ccf422f85CEF6638639 \
  "sendMessage(string,string,string)" "hedera" "0x50F6F2f19E571DeA309bD43eC501A5383d6Ae069" "test" \
  --rpc-url https://api.avax-test.network/ext/bc/C/rpc \
  --private-key $AVAX_KEY \
  --value 0.1ether
```

Example transaction:
[https://testnet.axelarscan.io/gmp/0x6e122a635b7bce03c2a76d7eab99e67280ba8bccff008dd8fee66abf6a287b7b](https://testnet.axelarscan.io/gmp/0x6e122a635b7bce03c2a76d7eab99e67280ba8bccff008dd8fee66abf6a287b7b) (
\~1m51s elapsed time)

#### 🔍 Check Result on Hedera

```bash
cast call 0x50F6F2f19E571DeA309bD43eC501A5383d6Ae069 "lastMessage()" \
  --rpc-url https://testnet.hashio.io/api
```

The received output will be raw - use `cast --to-utf8 0x00000...` to decode it.

---

## 📊 Observations

* The tx hash from `cast send` serves as both the **Root Chain tx hash** and **Axelar GMP trace ID**.
* The `--value` param is **mandatory** and pays for Axelar gas fees.
    * Fee estimates: `https://testnet.api.axelarscan.io/gas-payment/gas-fee/{sourceChain}/{destinationChain}`
    * Overpaid gas is refunded — see refund tx:
      [https://testnet.axelarscan.io/gmp/0xb4ed3c3343855d7bce64e11eaf159f7465bad49ebfcc75447ce05dfeab53728b](https://testnet.axelarscan.io/gmp/0xb4ed3c3343855d7bce64e11eaf159f7465bad49ebfcc75447ce05dfeab53728b)

---

