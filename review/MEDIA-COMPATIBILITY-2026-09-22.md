# BEARBULLS onchain media check — September 22, 2026

This is a bounded compatibility measurement, not an audit or marketplace certification. It covers minted creature #0000 in the existing v0.25 Robinhood testnet collection. It does not validate the undeployed v0.26 phased-mint candidate.

## Exact scope

- Collection: `0xBFE18B1F7FbF42Aa32B4E3455a020901d4D573EC`
- Chain ID verified: `46630`
- Token ID: `0`
- Block: `122730341`, hash `0x2246ddb71751d11d4eba6ff1e3d552bf208480c41617da4111e2bfc07a31b799`
- Check time: `2026-09-22T10:43:40.683Z`
- Endpoint: `https://rpc.testnet.chain.robinhood.com`, listed in [Robinhood network documentation](https://docs.robinhood.com/chain/connecting/).
- Three sequential `eth_call` reads against the same block from one machine/connection. No wallet or signer, no transaction, no payment.

## Observations

| Measurement | Result |
| --- | --- |
| tokenURI format | `data:application/json;base64,...` |
| tokenURI size | 124,385 bytes |
| JSON-RPC response size | 248,999 bytes per read, before any transport compression |
| Decoded metadata JSON | 93,265 bytes |
| PNG | 1,916 bytes; 512 × 512; embedded data URI |
| HTML animation | 66,711 bytes; embedded data URI |
| Request elapsed times | 708 ms, 659 ms, 742 ms |
| Median of this sample | 708 ms |
| Consistency | All three tokenURI strings identical; parsed metadata matches the saved historical minted-token metadata |
| External URL strings in HTML | None found by the HTTP/IPFS string check; this is not a complete sandbox/security analysis |
| Total minted at this block | 1; does not establish any outside collector participation |
| Historical mint price | 100 mock USDG; no monetary value; unchanged by the new $10 target |

The decoded HTML rendered the expected creature and name at a 375 × 812 browser viewport. Its logical canvas was 64 × 64, rendered at 375 × 375. No horizontal overflow or console errors were observed. The voice remained unactivated and Mute was initially disabled. This was local browser rendering of freshly retrieved onchain bytes, not an actual phone or a mobile network benchmark.

## Integrity fingerprints

- tokenURI SHA-256: `568c971f8344e4052dd6ddd49551f4d5d08389e7ad52c32b9c938563e4c13869`
- PNG SHA-256: `bbb1eb337e55472cdd01171deff91b7f824c13ee94dc53b67eea35a65d68112c`
- HTML SHA-256: `c0b934ac75cf1efe3ce4c3d02571dddde418f840e5e4e8a648a6c9d1bc55c184`

## What a marketplace integration should test

1. Accept the full RPC response and nested data URIs without truncating them. The outer RPC encoding makes the response considerably larger than the decoded PNG alone.
2. Decode the PNG thumbnail independently of animated HTML support.
3. Render HTML only inside the platform's appropriate isolated viewer; report unsupported media as a limitation rather than a successful integration.
4. Check actual wallet/browser display, cache behavior, request timeouts, reduced-motion handling and user-initiated audio on supported devices.
5. Distinguish collection metadata retrieval from marketplace indexing and display. OpenSea display remains unverified.

A single public endpoint and three samples cannot establish production latency, cross-provider consistency or availability. Robinhood describes the public endpoint as rate-limited and recommends a provider for production. A second independent RPC route has not been measured because no authorized provider endpoint was configured for this check.

Submit a reproducible compatibility result or failing test in the [voluntary review issue](https://github.com/bearbull-click/bearbull-click/issues/1). The published [review package](https://github.com/bearbull-click/bearbull-click/tree/main/review) contains the immutable artwork fixtures and contract tests.
