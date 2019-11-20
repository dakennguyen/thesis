pragma solidity ^0.5.0;

contract Types {
    mapping (string => string) public types;
    address private owner;

    constructor() public {
        owner = msg.sender;
        types['age'] = '/api/age';
        types['name'] = '/api/name';
        types['university'] = '/api/university';
    }

    function setValidator(string memory claimType, string memory link) public onlyOwner {
        types[claimType] = link;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
}
