// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["efflux", "congress", "pour", "credit", "cutting", "executrix", "barrier", "understand", "cultural", "dare"];
  string[] secondWords = ["card", "adjust", "appendix", "joint", "confusion", "announcement", "rocket", "reinforce", "birthday", "sip"];
  string[] thirdWords = ["contrary", "relinquish", "feeling", "responsible", "band", "seek", "tent", "cage", "blind", "thinker"];

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT Contract. Yay");
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  } 

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  } 

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  } 

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));


    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            // We set the title of our NFT as the generated word.
            combinedWord,
            '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
            // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");


    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    _tokenIds.increment();


  }
}