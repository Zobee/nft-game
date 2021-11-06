// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol"; 

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// OpenZeppelin helpers.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyEpicGame is ERC721 { //ERC721 is the standard NFT contract. Our contract will inherit from it
  struct CharAttrs {
    uint256 charInd;
    string name;
    string imgURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attack;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIDs;

  CharAttrs[] defaultChars;

  mapping(uint256 => CharAttrs) public nftHolderAttrs;

  mapping(address => uint256) public nftHolders; //You could change the uint into an array, if you wanted the user to be able to mint multiple NFTs

  constructor(
    string[] memory charNames,
    string[] memory charImgURIs,
    uint256[] memory charHp,
    uint256[] memory charAttack
  ) 
    ERC721("Jacks", "JACK")
  {
    for(uint i = 0; i < charNames.length; i += 1){
      defaultChars.push(CharAttrs({
        charInd: i,
        name: charNames[i],
        imgURI: charImgURIs[i],
        hp: charHp[i],
        maxHp: charHp[i],
        attack: charAttack[i]
      }));

      CharAttrs memory c = defaultChars[i];
      console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imgURI);
    }
      _tokenIDs.increment();
    }

    function mintJackNFT(uint _charInd) external {
      // Get current tokenId (starts at 1 since we incremented in the constructor).
      uint newItemId = _tokenIDs.current();
      _safeMint(msg.sender, newItemId);

      nftHolderAttrs[newItemId] = CharAttrs({
        charInd: _charInd,
        name: defaultChars[_charInd].name,
        imgURI: defaultChars[_charInd].imgURI,
        hp: defaultChars[_charInd].hp,
        maxHp: defaultChars[_charInd].hp,
        attack: defaultChars[_charInd].attack
      });

      console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _charInd);

      nftHolders[msg.sender] = newItemId; 

      _tokenIDs.increment();
  }
}