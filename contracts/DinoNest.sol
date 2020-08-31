// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.7.0 <0.8.0;

contract DinoNest {
    event DinoBorn(uint256 dinoId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Dino {
        string name;
        uint256 dna;
    }

    Dino[] public dinos;

    function _hatch(string memory _name, uint256 _dna) private {
        dinos.push(Dino(_name, _dna));
        emit DinoBorn(dinos.length - 1, _name, _dna);
    }

    function _mutateDna(string memory _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function hatchDino(string memory _name) public {
        uint256 randDna = _mutateDna(_name);
        _hatch(_name, randDna);
    }
}
