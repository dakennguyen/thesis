pragma solidity ^0.5.0;

contract Beerclub {
    mapping(address => string) public data;

    function setData(address client, string memory value) public onlyFromIdp() {
        data[client] = value;
    }

    function validate(address client, string memory attributeType) public returns(bool) {
    }
    
    modifier onlyFromIdp() {
        //require(msg.sender == 0x5963D7FA276fA797f174752A852AbfE32Db791D6, "Invalid");
        require(1 == 1);
        _;
    }

}
