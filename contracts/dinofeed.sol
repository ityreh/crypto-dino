// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity <=0.7.0 <0.8.0;

import "./dinonest.sol";

interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract DinoFeed is DinoNest {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function reproduce(
        uint256 _dinoId,
        uint256 _targetDna,
        string memory _species
    ) public {
        require(msg.sender == dinoToOwner[_dinoId]);
        Dino storage dino = dinos[_dinoId];
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (dino.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _hatch("NoName", newDna);
    }

    function feedOnKitty(uint256 _dinoId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        reproduce(_dinoId, kittyDna, "kitty");
    }
}
