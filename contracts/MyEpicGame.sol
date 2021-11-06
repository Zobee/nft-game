// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol"; 

contract MyEpicGame {
  struct CharAttrs {
    uint256 charInd;
    string name;
    string imgURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attack;
  }

  CharAttrs[] defaultChars;

  constructor(
    string[] memory charNames,
    string[] memory charImgURIs,
    uint256[] memory charHp,
    uint256[] memory charAttack
  ) {

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
  }
}