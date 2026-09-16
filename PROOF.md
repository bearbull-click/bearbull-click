# BEARBULLS v0.25 · Testnet verification record

This is a dated record of the project's **September 16, 2026** verification through the public Robinhood testnet RPC. It describes a testnet prototype, not a real-money release or an independent security audit.

## Network and contracts

| Item | Recorded value |
| --- | --- |
| Network | Robinhood testnet |
| Chain ID | `46630` |
| Collection | [`0xBFE18B1F7FbF42Aa32B4E3455a020901d4D573EC`](https://explorer.testnet.chain.robinhood.com/address/0xBFE18B1F7FbF42Aa32B4E3455a020901d4D573EC) |
| Immutable artwork renderer | [`0x22Fa6A26298001Ce784B95dfda67A20317713858`](https://explorer.testnet.chain.robinhood.com/address/0x22Fa6A26298001Ce784B95dfda67A20317713858) |
| Verification time | `2026-09-16T16:36:03.386Z` |
| Registered specimens | 100 |
| Recorded minted count | 1 at the verification time |

Artwork provenance commitment:

```text
0xebf21d1a0c86678e70d8f9420d6c9ef04308d2b2bf1bf4db439e75d0e54e70d4
```

A provenance commitment identifies the reviewed art package. It is not a price, an ownership address or a promise about future supply.

## What the checks covered

The project checked all **19 deployment and registration receipts**, the deployed contract runtime code, **17 art-data blob hashes**, and all **100 specimen assignments**. Readback checks covered every specimen's onchain metadata, PNG portrait and animation. The actual minted NFT's `tokenURI` also passed the readback checks.

Media was present at mint. The verified mint did not require IPFS uploads or a later thumbnail-finalization transaction.

## First test purchase

Specimen **#0000** was purchased in this transaction:

[`0x2241ca9d65bf6dc503946276e3880242cecab3a1d7e4b0d651fac16591410ca8`](https://explorer.testnet.chain.robinhood.com/tx/0x2241ca9d65bf6dc503946276e3880242cecab3a1d7e4b0d651fac16591410ca8)

The payment-flow check, recorded at `2026-09-16T16:37:16.388Z`, confirmed:

- Exactly **100 mock USDG** approved and paid.
- Payment and NFT delivery occurred in the same transaction, in block `120444806`.
- The remaining allowance was zero after purchase.

The preceding [approval transaction](https://explorer.testnet.chain.robinhood.com/tx/0x042c2c9f2a4ee76c40edb8a19b72fce233f422f07bce745120fbb19f20193680) and the [mock payment-token contract](https://explorer.testnet.chain.robinhood.com/address/0x85F72dC797f39ad93F73aFf8d59A74762d4D34EE) are available in the same explorer. Mock USDG has no monetary value; this transaction is not evidence of collector revenue or a working real-USDG payment route.

## What remains unverified

**OpenSea display and explorer source-code verification remain unverified.** Successful contract and media readback does not establish marketplace indexing or replace independent contract review. This page records the state observed on September 16; it is not a live mint counter.

A real-money launch has not been announced. BEARBULLS is an independent art project, with no Robinhood affiliation.

[Meet four BEARBULLS](README.md) · [Market Mood Roll Call on X](https://x.com/bearbullsclick)
