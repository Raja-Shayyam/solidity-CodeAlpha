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
    mapping (uint256 => mapping (address => bool)) public hasVoted;
    // mapping in solidity reverse chalti ha as compered to js hasvotes=>map ki hoi values_idr id ha => agy us se linked address_yahan ha => phir is adress se link true ya false_yahan pe ha 
    mapping (uint256 => mapping (uint8 => uint256)) public votesCount; // accha ab ye essy ha ke votesCount main pehly uint256=pollid ka ha us ko read kr ke hum us ke options tak pounch payin gy ie, 1,2.. aur us option ka count uint256 last waky amin
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

    function Vote(uint256 _polID, uint8 _pollOption)  external {
        poll storage pol = Polls[_polID];

        if(!pol.isActive) revert("not active");
        if(pol.EndTime < block.timestamp) revert("time had over");
        if(hasVoted[_polID][msg.sender]) revert ("your vote for this poll has been marked ");

        votesCount[_polID][_pollOption] ++ ;
        hasVoted[_polID][msg.sender] = true;

    }

    function Result(uint256 _polID) external view returns(string memory title, string[] memory options, uint256[] memory counts){
        poll storage pol = Polls[_polID];

        title = pol.title;
        uint n = pol.options.length;

        counts = new uint256[](n);
        for (uint8 i ; i<n ; i++) 
        {
            counts[i] = votesCount[_polID][i];
        }
// ["cpp","js","sol","rust"]
// ["cpp","javaScriot","solidity","rust"]
        return(title,pol.options, counts);

    }

    function AdminControl(uint256 _polID, uint16 _time, bool _allow) external  {
        if(!(admin==msg.sender)) revert("not aligible to change");
        if(!(_time < Polls[_polID].EndTime)) revert ("ye time kam ho jay ga");

        Polls[_polID].EndTime = _time;
        Polls[_polID].isActive = _allow;
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
