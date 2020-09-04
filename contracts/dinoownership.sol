pragma solidity <=0.7.0 <0.8.0;

import "./dinoattack.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DinoOwnership is DinoAttack, ERC721 {
    mapping(uint256 => address) dinoApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerDinoCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return dinoToOwner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            dinoToOwner[_tokenId] == msg.sender ||
                dinoApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        onlyOwnerOf(_tokenId)
    {
        dinoApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) {
        ownerDinoCount[_from]--;
        ownerDinoCount[_to] = ownerDinoCount[_to].add(1);
        dinoToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
}
