// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol"; 

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// OpenZeppelin helpers.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Base64 Encoding
import "./libraries/Base64.sol";

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

  struct Boss {
    string name;
    string imgURI;
    uint hp;
    uint maxHp;
    uint attack;
  }

  Boss public boss;


  mapping(address => uint256) public nftHolders;

  constructor(
    string[] memory charNames,
    string[] memory charImgURIs,
    uint256[] memory charHp,
    uint256[] memory charAttack,
    string memory bossName,
    string memory bossImgURI,
    uint bossHp,
    uint bossAttack
  ) 
    ERC721("Jacks", "JACK")
  {

    boss = Boss({
      name: bossName,
      imgURI: bossImgURI,
      hp: bossHp,
      maxHp: bossHp,
      attack: bossAttack
    });

    console.log("Done initializing boss %s w/ HP %s, img %s", boss.name, boss.hp, boss.imgURI);

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

  function tokenURI(uint256 _tokenId) public view override returns (string memory){
    CharAttrs memory charAttrs = nftHolderAttrs[_tokenId];

    string memory strHp = Strings.toString(charAttrs.hp);
    string memory strMaxHp = Strings.toString(charAttrs.maxHp);
    string memory strAttack = Strings.toString(charAttrs.attack);

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "}',
            charAttrs.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            "image: ",
            charAttrs.imgURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',strAttack,'} ]}'
          )
        )
      )
    );
    string memory output = string(
    abi.encodePacked("data:application/json;base64,", json)
    );
  
    return output;
  }

  function attackBoss() public {
    // Get the state of the player's NFT.
    uint256 playerToken = nftHolders[msg.sender];
    CharAttrs storage player = nftHolderAttrs[playerToken];
    console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attack);
    console.log("Boss %s has %s HP and %s AD", boss.name, boss.hp, boss.attack);

    // Make sure the player has more than 0 HP.
    require (
      player.hp > 0,
      "Error: Your character is dead and cannot attack (RIP)."
    ); 

    // Make sure the boss has more than 0 HP.
    require (
      boss.hp > 0,
      "Error: The boss has been defeated already. No sense beating a dead horse."
    );

    // Allow player to attack boss.
    if (boss.hp < player.attack) {
      boss.hp = 0; //uints can't be negative, so we need to manually handle that case
    } else {
      boss.hp = boss.hp - player.attack;
    }

    // Allow boss to attack player.
    if (player.hp < boss.attack) {
      player.hp = 0;
    } else {
      player.hp = player.hp - boss.attack;
    }

    console.log("Player attacked boss. New boss hp: %s", boss.hp);
    console.log("Boss attacked player. New player hp: %s\n", player.hp);
  }
}