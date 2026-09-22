// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BearBullsArt} from "./BearBullsArt.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @notice Phased 100-creature review candidate. No rewards, pool or collection token.
/// @dev TESTNET ONLY. 10 mock USD units is not a live USD quote or real USDG integration.
/// Art assignments cannot be replaced and use original specimen IDs. The release owner
/// must supply verified immutable BearBullsArt code; the Solidity type is not code authentication.
contract BearBullsPhasedDrop is ERC721, ERC2981, Ownable2Step, Pausable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    uint256 public constant MAX_SUPPLY = 10_000;
    uint256 public constant MAX_RELEASE_SIZE = 100;
    uint256 public constant PRICE = 10 * 10 ** 6;
    uint96 public constant ROYALTY_BPS = 420;
    uint256 public constant EARLY_CAP = 50;
    uint256 public constant PUBLIC_DELAY = 24 hours;
    uint256 public constant BONUS_DELAY = 48 hours;
    IERC20 public immutable paymentToken;
    address public immutable treasury;
    uint256 public totalReleased;
    uint256 public totalMinted;
    mapping(address => uint256) public mintedBy;

    struct Release {
        BearBullsArt art;
        bytes32 provenance;
        uint64 startsAt;
        uint16 count;
        uint16 minted;
        bytes32 allowlistRoot;
    }

    struct Assignment {
        address art;
        uint16 artIndex;
        uint16 releaseIndex;
    }
    Release[] public releases;
    mapping(uint256 => Assignment) public assignments;

    error InvalidConfiguration();
    error PreviousReleaseNotSoldOut();
    error DuplicateSpecimen();
    error NotAvailable();
    error WalletLimit();
    error InvalidProof();
    error EarlyAllocationSoldOut();
    error UnsupportedPayment();
    event ReleaseRegistered(
        uint256 indexed releaseIndex,
        address indexed art,
        bytes32 provenance,
        uint256 count,
        uint64 startsAt,
        bytes32 allowlistRoot
    );
    event CreaturePurchased(
        address indexed collector, uint256 indexed tokenId, uint256 indexed releaseIndex, uint256 amount
    );
    event ProceedsWithdrawn(address indexed treasury, uint256 amount);

    constructor(address initialOwner, address treasury_, IERC20Metadata paymentToken_)
        ERC721("BEARBULLS Phased Drop Testnet", "BBP-TEST")
        Ownable(initialOwner)
    {
        if (block.chainid != 46630 && block.chainid != 31337) revert InvalidConfiguration();
        if (
            treasury_ == address(0) || treasury_ == address(this) || address(paymentToken_).code.length == 0
                || paymentToken_.decimals() != 6
        ) revert InvalidConfiguration();
        treasury = treasury_;
        _setDefaultRoyalty(treasury_, ROYALTY_BPS);
        paymentToken = IERC20(address(paymentToken_));
        _pause();
    }

    /// @notice Register exactly 100 frozen creatures; later batches require the previous one to sell out.
    /// No future batch can overwrite a prior specimen or its media. Later releases need not happen.
    function registerRelease(BearBullsArt art_, uint64 startsAt, bytes32 allowlistRoot) external onlyOwner {
        // Root, opening time and art become fixed together. Pausing never resets the clock.
        if (address(art_).code.length == 0 || startsAt <= block.timestamp || allowlistRoot == bytes32(0)) {
            revert InvalidConfiguration();
        }
        uint256 count = art_.supply();
        bytes32 provenance = art_.provenanceHash();
        if (count != MAX_RELEASE_SIZE || totalReleased + count > MAX_SUPPLY || provenance == bytes32(0)) {
            revert InvalidConfiguration();
        }
        uint256 index = releases.length;
        if (index > 0 && releases[index - 1].minted != releases[index - 1].count) revert PreviousReleaseNotSoldOut();
        for (uint256 i; i < count; ++i) {
            uint256 id = art_.specimenId(i);
            if (id >= MAX_SUPPLY) revert InvalidConfiguration();
            if (assignments[id].art != address(0)) revert DuplicateSpecimen();
            assignments[id] = Assignment(address(art_), uint16(i), uint16(index));
        }
        releases.push(Release(art_, provenance, startsAt, uint16(count), 0, allowlistRoot));
        totalReleased += count;
        emit ReleaseRegistered(index, address(art_), provenance, count, startsAt, allowlistRoot);
    }

    /// @notice Choose a particular released creature. Payment and NFT delivery succeed or revert together.
    function mint(uint256 tokenId, uint8 tier, bytes32[] calldata proof) external nonReentrant whenNotPaused {
        Assignment memory a = assignments[tokenId];
        if (a.art == address(0) || _ownerOf(tokenId) != address(0)) revert NotAvailable();
        Release storage r = releases[a.releaseIndex];
        if (block.timestamp < r.startsAt) revert NotAvailable();
        uint256 elapsed = block.timestamp - uint256(r.startsAt);
        uint256 limit = 1;
        if (elapsed < PUBLIC_DELAY) {
            if (r.minted >= EARLY_CAP) revert EarlyAllocationSoldOut();
            _verify(r.allowlistRoot, a.releaseIndex, msg.sender, tier, proof);
        } else if (elapsed >= BONUS_DELAY && tier != 0) {
            _verify(r.allowlistRoot, a.releaseIndex, msg.sender, tier, proof);
            if (tier == 3) limit = 3;
        }
        if (mintedBy[msg.sender] >= limit) revert WalletLimit();
        ++mintedBy[msg.sender];
        ++r.minted;
        ++totalMinted;
        uint256 beforeBalance = paymentToken.balanceOf(address(this));
        paymentToken.safeTransferFrom(msg.sender, address(this), PRICE);
        if (paymentToken.balanceOf(address(this)) != beforeBalance + PRICE) revert UnsupportedPayment();
        _safeMint(msg.sender, tokenId);
        emit CreaturePurchased(msg.sender, tokenId, a.releaseIndex, PRICE);
    }

    /// @notice Double-hashed, sorted-pair Merkle leaf; bound to chain, collection and release.
    /// Tier 1 means ordinary eligibility; tier 3 means three lifetime mints only after 48h.
    function allowlistLeaf(uint256 releaseIndex, address collector, uint8 tier) public view returns (bytes32) {
        return
            keccak256(bytes.concat(keccak256(abi.encode(block.chainid, address(this), releaseIndex, collector, tier))));
    }

    function _verify(bytes32 root, uint256 releaseIndex, address collector, uint8 tier, bytes32[] calldata proof)
        private
        view
    {
        if (
            (tier != 1 && tier != 3)
                || !MerkleProof.verifyCalldata(proof, root, allowlistLeaf(releaseIndex, collector, tier))
        ) revert InvalidProof();
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        Assignment memory a = assignments[tokenId];
        return BearBullsArt(a.art).tokenURI(a.artIndex);
    }

    /// @dev ERC-2981 signals the royalty; third-party marketplaces decide whether to pay it.
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function releaseCount() external view returns (uint256) {
        return releases.length;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function resume() external onlyOwner {
        _unpause();
    }

    function withdraw() external onlyOwner nonReentrant {
        uint256 amount = paymentToken.balanceOf(address(this));
        paymentToken.safeTransfer(treasury, amount);
        emit ProceedsWithdrawn(treasury, amount);
    }
}
