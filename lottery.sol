// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    function recieve() external payable {
        require(msg.value == 1 ether , "ether is not enough" );
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint){
        require(msg.sender== manager,"only the manager is allow to call this function");
        return address(this).balance;
    }

    function random() private view returns(uint){
        return uint (keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender== manager,"only the manager is allow to call this function");
        require(participants.length >= 3, "minimum number of partcipants should be 3");
        uint r=random();
        address payable winner;
        uint index = r%participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}