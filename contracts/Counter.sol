// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract codeAlpha__counter {
    uint16 public counter;

    function Incr_real() public {
        counter++; // Increment the counter by 1
    }

    function Decr_real() public {
        if (counter > 0) {
            counter--; // Decrement the counter by 1 if it is greater than 0
        }
    }   

    function show_fake_Inrementing() public view returns(uint16){
        uint16 count = counter;
        return ++count;
    }

    function show_fake_decrementing() public view returns(uint16){
        uint16 count = counter;
        return --count;
    }
}