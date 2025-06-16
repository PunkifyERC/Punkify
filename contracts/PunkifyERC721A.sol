// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./generator.sol";

contract PunkifyNFT is ERC721AQueryable, Ownable, Generator {
    address public minter;

    constructor() ERC721A("Punkify", "P") Ownable(tx.origin) {
        minter = tx.origin;
    }

    function setMinter(address val) external onlyOwner {
        minter = val;
    }

    function mint(uint256 quantity, address to) external {
        require(msg.sender == minter , "access denied. #1");
        _mint(to, quantity);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721A, IERC721A) returns (string memory) {
    require(_exists(tokenId), "Token does not exist");

    // Generate the SVG image dynamically
    string memory svg = getPunkSVG(tokenId);

    // Encode the SVG to base64 to embed in metadata
    string memory image = Base64.encode(bytes(svg));

    // Generate trait values based on tokenId
    string memory faceColor = randomColor(tokenId, face_colors, "face");
    string memory eyeColor = randomColor(tokenId, eye_colors, "eyes");
    string memory noseColor = randomColor(tokenId, nose_colors, "nose");
    string memory mouthColor = randomColor(tokenId, mouth_colors, "mouth");
    string memory crownColor = randomColor(tokenId, crown_colors, "crown");
    string memory sparklesAttr = shouldShowSparkles(tokenId) ? "Yes" : "No";

    // Construct the metadata JSON with attributes
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{',
                        '"name":"Punkify #', _toString(tokenId), '",',
                        '"description":"ERC-PIN is a next-generation standard for unique, verifiable, and fully on-chain Punk identities on Ethereum.",',
                        '"image":"data:image/svg+xml;base64,', image, '",',
                        '"attributes":[',
                            '{"trait_type":"Face Color","value":"', faceColor, '"},',
                            '{"trait_type":"Eye Color","value":"', eyeColor, '"},',
                            '{"trait_type":"Nose Color","value":"', noseColor, '"},',
                            '{"trait_type":"Mouth Color","value":"', mouthColor, '"},',
                            '{"trait_type":"Crown Color","value":"', crownColor, '"},',
                            '{"trait_type":"Sparkles","value":"', sparklesAttr, '"}',
                        ']',
                    '}'
                )
            )
        )
    );

        // Return the full data URI
        return string(abi.encodePacked("data:application/json;base64,", json));
    }


    /// @notice Returns all token IDs owned by `owner`
    function getMy(address owner) public view returns (uint256[] memory) {
        return this.tokensOfOwner(owner);
    }
}
