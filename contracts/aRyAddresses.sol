// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract arrayAddresses {
    // bool stop = true;
    address admin;
    address[] recipents;


    // function stopIt() public {
    //     stop = false;
    // }
    constructor()  {
        admin = msg.sender;
    }

    function takeAddresses(address _Address) public {
        recipents.push(_Address);
    }

    function sharingEqualETH() public payable {
        require((msg.sender==admin), "you are not admin");
        require(msg.value > 0,"please send some ETH");
        require(recipents.length>1,"should be atleast 2 recipents for equal sharings .... ");
        uint256 amounToSend = msg.value / recipents.length;
         for (uint256 i = 0; i < recipents.length; i++){
            payable ( recipents[i]).transfer(amounToSend);
         }
    }

    function getBalance() public view returns (uint256)  {
        return address(this).balance;
    }
    function getMsgValue() public payable returns (uint256) {
        return msg.value;
    }



}

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
// 0x617F2E2fD72FD9D5503197092aC168c91465E7f2

// address payable[] memory recipents