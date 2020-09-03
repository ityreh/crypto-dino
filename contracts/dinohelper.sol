// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity <=0.7.0 <0.8.0;

import "./dinofeed.sol";

contract DinoHelper is DinoFeed {
    modifier aboveLevel(uint256 _leve, uint256 _dinoId) {
        require(dinos[_dinoId].level >= _level);
        _;
    }

    function changeName(uint256 _dinoId, string calldata _newName)
        external
        aboveLevel(2, _dinoId)
    {
        require(msg.sender == dinoToOwner[_dinoId]);
        dinos[_dinoId].name = _newName;
    }

    function changeDna(uint256 _dinoId, uint256 _newDna)
        external
        aboveLevel(20, _dinoId)
    {
        require(msg.sender == dinoToOwner[_dinoId]);
        dinos[_dinoId].dna = _newDna;
    }

    function getDinoByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = uint256[](ownerDinoCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < dinos.length; i++) {
            if (dinoToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
