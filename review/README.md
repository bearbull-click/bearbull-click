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