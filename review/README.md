# BEARBULLS volunteer contract review

Snapshot: phased pilot / 4.2% royalties, September 22, 2026. This is a request for free voluntary technical review, not a claim of an independent audit. No bounty or payment is offered.

## Scope

- **New candidate:** `contracts/onchain/BearBullsPhasedDrop.sol` — $10 target represented as 10 mock USD units, 50/50 pilot allocation, 24/48-hour windows, Merkle tiers and 4.2% ERC-2981 royalties.
- **Shared artwork:** `BearBullsArt.sol`, `ImmutableBlob.sol` — immutable blob commitments, metadata, embedded PNG thumbnails and HTML animation.
- **Historical regression:** `BearBullsCreatureDrop.sol` is the unchanged v0.25 testnet source with its original 100 mock USDG price. It is not the new sale candidate.
- **Test asset only:** `contracts/vault/MockUSDG.sol`; not production USDG.

Neither this review package nor its tests open mainnet minting. No new candidate deployment, real USDG integration, real wallet allowlist, independent audit or marketplace royalty enforcement is claimed.

The source beside this README is a browsing copy. Download [the complete review archive](bearbulls-phased-review-v026.zip) for its directory structure, imports, tests and pinned dependencies. Verify it against [SHA256SUMS](SHA256SUMS).

## Reproduce

Use Foundry with Solidity 0.8.24, Cancun, optimizer 200 runs, and Node.js. Dependency versions are pinned. From the extracted package root:

```sh
npm ci
forge test -vv
node --test tests/launch-config.test.mjs
```

The local verification used Foundry 1.7.1, OpenZeppelin Contracts 5.4.0 and 256 runs per fuzz test. The package includes the exact blob fixtures needed by the tests; these are artwork data, not deployment secrets. SHA256SUMS identifies the files under review. Review findings apply to that exact snapshot, not all later changes.

## Invariants to challenge

1. Only the first 50 creatures can sell before 24 hours, only with the correct wallet/tier proof.
2. Public supply at 24 hours includes the reserved 50 and all leftovers.
3. Every wallet is limited to one primary mint before 48 hours. A proven top-tier wallet may reach three total afterward. Transfers and later releases cannot reset counters.
4. Proofs are bound to chain, collection, release, wallet and tier.
5. Payment, counters and safe NFT delivery revert atomically on failure or receiver rejection. Reentrancy cannot obtain an extra mint.
6. Registered specimen IDs, artwork assignments, root and start time cannot be overwritten.
7. PNG/animation/JSON are available immediately after mint, with no external media service or finalization transaction.
8. `royaltyInfo` returns the fixed treasury and sale price × 420 / 10000, rounded down. Ownership transfer cannot redirect royalties. Primary mint stays 10 mock units.
9. Only the owner may pause/resume/register or withdraw; proceeds can only go to the fixed treasury.

## Known boundaries and open work

The owner chooses the art contract and allowlist root. A Solidity `BearBullsArt` type does not authenticate runtime bytecode: the release process must verify the immutable renderer and its data before registration. Blob commitments prove which bytes were registered, not that every byte is semantically valid. Owner mistakes in an immutable root/time cannot be corrected in place. The owner can pause minting; the phase clock still advances. A funded wallet can acquire multiple wallets, so wallet caps do not prevent Sybil behavior. Later batches require prior sellout and are not promised.

ERC-2981 is a royalty signal, not transfer-level payment enforcement. Third-party marketplaces may ignore it. Fixed mock token units do not establish a dollar peg or a canonical real-token route. No actual ranked snapshot exists yet. The candidate's wallet interface and deployment rehearsal remain to be prepared. Mainnet is explicitly rejected by this contract.

## How to contribute

Open a repository issue with the snapshot hash, affected contract/function, expected versus actual behavior, and a minimal local Foundry reproduction. Use only local/testnet reproduction; do not attack live contracts, other users or third-party services. Do not post credentials or private data. Findings stay unverified until reproduced; fixes require regression tests and a new snapshot hash. Reviewer attribution is optional and only with consent. A published request or passing test suite must never be labeled an independent audit.
