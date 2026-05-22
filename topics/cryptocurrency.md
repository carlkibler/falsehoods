# Falsehoods About Cryptocurrency

> Crypto's clean abstractions hide jagged, irreversible edges.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Bitcoin's supply is not exactly 21 million — and it has briefly been over 184 billion.** The asymptote rounds to 20,999,999.9769 BTC, and miner underpayment lowers it further. Worse, in August 2010 at block #74638 an integer-overflow bug let someone mint two outputs of ~92.2 billion BTC each. The bad chain survived for nearly seven hours (block timestamps 17:02 to 23:53) before a patched majority rejected it.

- **Bitcoin has had a double spend.** On March 11, 2013, a v0.7/v0.8 chain fork (block #225430) split the network. A user paid OKPay 211.9 BTC, saw it confirm on the v0.8 fork, then deliberately double-spent the same inputs into the pre-0.8 fork — costing OKPay $10,000. Waiting for confirmations would not have saved them.

- **Block height can go *down*.** The honest chain is the one with the most cumulative *chainwork*, not the most blocks. A chain with more blocks but lower difficulty can be replaced by a shorter, heavier chain — so a node's valid block height can actually decrease.

- **Smart contracts are not immutable.** Even with no `DELEGATECALL`, a contract can `CALL` (or `STATICCALL`) into a variable address and use the result. Deploy via `CREATE2` plus `selfdestruct` and the "owner" can destroy a contract and redeploy *different code at the same address*. You must trace the entire deployment chain back to an EOA.

- **`estimateGas` does not tell you what your transaction will cost.** It returns the gas needed *if mined now*; the chain state at mining time can send your tx down a different code path. Even identical code can differ: an `SSTORE` to a fresh slot costs far more than to an existing one (EIP-2200), so the first ERC20 transfer to a new address is more expensive than the second.

- **A finite Bitcoin supply was not enforced from the start.** Satoshi originally programmed the money supply to grow *indefinitely, forever* — modeled as 4 gold mines per "mibillennium" (1024 years). The finite cap was a deliberate, controversial change introduced by Pieter Wuille in BIP42 in 2014.

- **ETH supply can decrease.** Lost-key and zero-address ETH still exists, just inaccessible. But `selfdestruct`-ing a contract with itself as the recipient genuinely erases its ETH. Burn more than the block reward and you can make Ether deflationary for ~10 seconds.

- **You can force ETH into a contract that "rejects" all transfers.** Declaring no `payable` methods does not protect you. ETH can arrive via `selfdestruct` beneficiary, block-reward beneficiary, or by pre-funding a precalculated `CREATE2` deployment address before deployment — none of which triggers your code.

- **Block time does not only increase.** A block may carry a *lower* timestamp than its predecessor. Bitcoin only requires the timestamp to exceed the median of the previous 11 blocks and to be under network-adjusted time + 2 hours. As the source code warns: "Never go to sea with two chronometers; take one or three."

## Where It Gets Complicated

Most of these only bite if you touch consensus, the mempool, or the EVM directly — but if you do, the abstractions stop holding.

### Blocks and mining

- **A valid block is not guaranteed inclusion.** Even a single-handedly mined valid block is ignored if its hash collides with an earlier block's — its inventory vector looks like a duplicate, so no node requests it.
- **Block reward is not constant.** Block #124724's coinbase is missing one satoshi; block #501726 omits the *entire* reward.
- **More leading zeros do not mean more chainwork.** Any hash below the target is equally valid; chainwork is computed only from the difficulty (`nBits`) active at the time, not from how low the hash happened to land.
- **Difficulty adjustment uses 2015 blocks, not 2016** — a well-known off-by-one bug in the algorithm.
- **Empty blocks aren't empty.** They still carry an 80-byte header and a coinbase transaction, and still cost full Proof of Work; they just lack mempool transactions.

### Transactions and the mempool

- **Mempool is not a waiting room with guaranteed exit.** When a node hits `maxmempool` it drops the lowest-feerate transactions and raises its `mempoolminfee`. Every node decides independently.
- **A transaction can reach a block without ever being in your mempool**, and seeing it in your mempool does not mean every node sees it — propagation takes time, and nodes may decline it at will.
- **Mempool rejection does not mean invalid.** A tx below a node's configurable `minrelaytxfee` won't be relayed but can still be mined.
- **A confirmed transaction is not forever** — a reorg can undo it.
- **A transaction has neither exactly one sender nor exactly one receiver**, and its output destination is not always an address (e.g. `OP_RETURN`).
- **Fees aren't explicit.** The fee is `sum(inputs) - sum(outputs)`, computed, not stated. And not every transaction pays one — the only rule is fee ≥ 0 (see the zero-fee tx where inputs equal outputs).
- **Transaction hashes aren't all unique.** BIP30 had to forbid a block from containing a tx whose ID matches an earlier, not-fully-spent one.
- **RBF, replacements, and txids are slippery.** An RBF-marked tx isn't always replaceable; a non-RBF tx with a healthy fee isn't guaranteed to land as-is; an unconfirmed payment's txid *can* change without being a malicious double-spend; and a higher-fee replacement only wins if it reaches the miner before the block finalizes — so you must track every prior hash for that nonce.

### Gas (Ethereum)

- **Identical state doesn't guarantee identical gas** if a hardfork reprices operations in between (EIP-1679). You can't safely hardcode gas limits unless you ship an update every hardfork.
- **`estimateGas` only inspects the outer tx, not internal calls.** Multisigs like Gnosis Safe mark operations executed [even on failure](https://github.com/gnosis/safe-contracts/blob/94f9b9083790495f67b661bfa93b06dcba2d3949/contracts/GnosisSafe.sol#L158-L159), so a naive estimate covers the wrapper but starves the inner call — which is why Safe ships a dedicated estimation method.
- **Comparing gas used vs. gas limit is not a reliable out-of-gas detector**, since an internal call can exhaust its stipend while the tx still has plenty.
- **"Just send more gas" can backfire** — a contract can inspect received gas and deliberately fail if given too much.

### Nonces, logs, and reorgs

- **`getTransactionCount('latest')` ignores pending txs** and can overwrite them; `'pending'` is better but the node may not hold all your in-flight transactions.
- **Polling `getLogs` on `latest` misses reorgs** — you're never told that already-seen blocks were reorged. Filters report removed events too, but only if the node stays online and keeps filter state (Infura long lacked filters over HTTP, which Metamask uses by default). WebSocket subscriptions just add more things that must stay online and connected. See EIP-234 and `ethereumjs-blockstream`.

### Wallets, keys, and addresses

- **Derivation paths aren't universal.** Not all wallets use standardized paths, and a seed phrase alone may not recover a wallet (passphrase, account gaps, non-standard schemes). There is more than one mnemonic standard.
- **A derivation index can yield no address.** BIP32 uses HMAC-SHA512; a result of 0 or ≥ the secp256k1 order `n` is an invalid key (probability under 1 in 2^127), so wallets skip that index — leaving a gap. pycoin even ships a special error message for it.
- **Two different xpub strings can derive the same addresses.** The `depth` and `parent fingerprint` metadata can be wiped to `0x0`; the base58 string changes completely but the key material — and resulting addresses like `1BiCdXSDHyeXSzmx2paVPFVTrmyx7BeCGD` — stay identical.
- **Keys and addresses aren't one-to-one.** A private key doesn't map to exactly one address, an address doesn't have exactly one private key, and you can't always derive an address from an input/output.
- **Address strings vary.** Not all Bitcoin addresses share a length, and not all are case-sensitive (Bech32 is case-insensitive).
- **Paper-wallet sweeps can drain the lot.** Spending "part" of a paper wallet can move *all* of it, and a wallet's "sweep paper wallet" change won't necessarily return to the printed address.
- Compressed WIF keys aren't shorter than uncompressed; not every integer 1..2^256 is a valid key; you can't always convert a raw private key into a BIP39 mnemonic; and handing out a non-hardened child private key to someone holding the xpub can compromise the whole branch.

### Privacy

- **Bitcoin is pseudonymous, not anonymous.** Every coin has a fully visible ownership history; addresses are just strings, reused freely, and multisig addresses can hold funds for several people.
- **Inputs in one transaction aren't necessarily one owner** — CoinJoin and similar break the "common input ownership" heuristic.

### Exchanges

- **"Get your coins off of exchanges."** Withdrawals aren't always allowed; the coins in your account may not be *yours*, may not even *exist*, and a placed order isn't guaranteed to execute. Even ask ≥ bid can fail to hold on a broken book.

### UTXOs and ERC20

- **Not all UTXOs are spendable.** The genesis block's 50 BTC is provably unspendable, as are `OP_RETURN` outputs and burn addresses like `1BitcoinEaterAddressDontSendf59kuE` — plus countless lost-key coins.
- **ERC20 `transfer` may not credit the recipient the amount debited from the sender** — deflationary/fee-on-transfer tokens skim in transit (see the Balancer incident). Treat balances, not transfer arguments, as truth.

## If You Build This

- **Never assume monotonicity or finality.** Block height, block time, supply caps, and confirmed transactions can all move backward. Design for reorgs explicitly: track every txid you've broadcast per nonce, and reconcile on chain state, not on what you sent.
- **Never hardcode gas.** Re-estimate per transaction, account for hardfork repricing, and for multisig/internal-call paths use protocol-specific estimation (e.g. Gnosis Safe's dedicated method) rather than `estimateGas` alone.
- **Verify, don't trust, immutability.** Before treating a contract as immutable, trace its deployment chain to an EOA and check for `CALL`/`STATICCALL`/`DELEGATECALL`, `CREATE2`, and `selfdestruct`.
- **Use `SafeERC20` (OpenZeppelin) for token interactions**, and measure recipient balance deltas instead of trusting transfer amounts.
- **Compute fees and balances from the chain.** Fees are `sum(inputs) - sum(outputs)`; a contract's ETH balance can exceed the sum of transfers it processed. Reconstruct state, don't infer it.
- **Treat the mempool as advisory.** Acceptance, propagation, and inclusion are independent; relay policy (`minrelaytxfee`, `maxmempool`, `pricebump`) is per-node and configurable, so build in resubmission and monitoring.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Bitcoin (spring-boot-bitcoin)](https://github.com/theborakompanioni/spring-boot-bitcoin-starter/blob/master/docs/FALSEHOODS.md) · [archived copy](../archive/cryptocurrency/01-falsehoods-about-bitcoin-spring-boot-bitcoin.md)
- [Falsehoods about Cryptocurrencies (spalladino)](https://gist.github.com/spalladino/a349f0ca53dbb5fc3914243aaf7ea8c6) · [archived copy](../archive/cryptocurrency/02-falsehoods-about-cryptocurrencies-spalladino.md)
