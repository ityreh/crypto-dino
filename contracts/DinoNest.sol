// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.7.0 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract DinoNest is Ownable {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event DinoBorn(uint256 dinoId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldownTime = 1 days;

    struct Dino {
        string name;
        uint256 dna;
        uint32 level;
        // uint64 because of 2038 problem
        uint64 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Dino[] public dinos;

    mapping(uint256 => address) public dinoToOwner;
    mapping(address => uint256) ownerDinoCount;

    function _hatch(string memory _name, uint256 _dna) internal {
        dinos.push(Dino(_name, _dna, 1, uint64(now + cooldownTime), 0, 0));
        uint256 id = dinos.length - 1;
        dinoToOwner[id] = msg.sender;
        ownerDinoCount[msg.sender] = ownerDinoCount[msg.sender].add(1);
        emit DinoBorn(id, _name, _dna);
    }

    function _mutateDna(string memory _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function hatchDino(string memory _name) public {
        require(ownerDinoCount[msg.sender] == 0);
        uint256 randDna = _mutateDna(_name);
        _hatch(_name, randDna);
    }
}
