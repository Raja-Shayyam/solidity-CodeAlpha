// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract voting {
    struct poll {
        bool isActive;
        uint256 EndTime;
        string[] options;
        string title;
    }

    mapping(uint => poll) public Polls;
    uint256 public totalpolls;
    address public admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function Create_poll(
        string calldata _title,
        string[] calldata _options,
        uint256 _duration
    ) external {
        require(msg.sender == admin, "you are not admin");
        require(_options.length > 2, "must more than 2 options");

        uint256 _endTime = block.timestamp + (_duration * 60);
        Polls[totalpolls] = poll({
            title: _title,
            options: _options,
            isActive: true,
            EndTime: _endTime
        });
        totalpolls++;
    }

    function check(
        uint256 _indx
    )
        public
        view
        returns (
            bool isActive,
            uint256 EndTime,
            string[] memory options,
            string memory title
        )
    {
        poll storage pooll = Polls[_indx];
        return (pooll.isActive, pooll.EndTime, pooll.options, pooll.title);
        // return (Polls[_indx].isActive, Polls[_indx].EndTime, Polls[_indx].options, Polls[_indx].title);
    }
}
