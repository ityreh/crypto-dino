// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity <=0.7.0 <0.8.0;

import "./dinohelper.sol";

contract DinoAttack is DinoHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        ownerOf(_zombieId)
    {
        Dino storage myDino = dinos[_dinoId];
        Dino storage enemyDino = dinos[_targetId];
        uint256 rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myDino.level++;
            myDino.winCount++;
            enemyDino.lossCount++;
            reproduce(_zombieId, enemyDino.dna, "dino");
        } else {
            myDino.lossCount++;
            enemyDino.winCount++;
            _triggerCooldown(myDino);
        }
    }
}
