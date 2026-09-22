# Volunteer review: phased BEARBULLS mint + 4.2% royalties

BEARBULLS is preparing a small Robinhood Chain pilot. We would welcome free voluntary review of this testnet-only contract candidate before any mainnet deployment.

The candidate implements a $10 mint target using 10 mock USD units, 50 early / 50 public supply, a 24-hour public opening, three total mints for a proven top tier after 48 hours, and fixed 4.2% ERC-2981 royalties to the treasury. Metadata, PNG and animation are stored onchain and available immediately after mint.

Download `bearbulls-phased-review-v026.zip`; its SHA-256 is `c41a09819a8d35546c62bc0e4542cfffa9ff2c97189e1d8081d9bd8eb65411b0`.

See README.md for scope, reproduction and known boundaries. The package passed 43 contract tests (including two fuzz tests with 256 runs each) and nine launch-configuration tests. The full development project passed 78 contract tests and 68 JavaScript tests. These are internal checks, not an independent audit.

Please focus on phase boundaries, inventory protection, proof replay, wallet limits, payment/reentrancy behavior, immutable metadata and royalty recipient/rate. Report the snapshot hash and a minimal local reproduction in an issue. No bounty or reviewer payment is offered; credit is optional. Do not attack live systems or post private data.

The candidate is not deployed, the actual eligibility snapshot is not built, and real USDG checkout remains unverified. The existing v0.25 testnet collection is unchanged. Mainnet preparation continues; no launch date or sale opening is announced.
