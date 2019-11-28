pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './lib/strings.sol';

contract Beerclub {
    using strings for *;

    mapping(address => RawData) private clients;

    struct RawData {
        string value;
        uint count;
    }

    struct Data {
        string attributeType;
        bytes32 hash;
        string signature;
    }

    function getData(address client) public returns(Data[] memory) {
        strings.slice memory s = clients[client].value.toSlice();
        strings.slice memory space = " ".toSlice();
        strings.slice memory colon = ":".toSlice();
        strings.slice[] memory parts = new strings.slice[](s.count(space));

        Data[] memory result = new Data[](clients[client].count);

        for(uint i = 0; i < parts.length; i++) {
            parts[i] = s.split(space);
            result[i] = Data(parts[i].split(colon).toString(), sha256(bytes(parts[i].split(colon).toString())), parts[i].split(colon).toString());
        }
        return result;
    }

    function setData(address client, string memory value, uint count) public onlyFromIdp() {
        clients[client].value = value;
        clients[client].count = count;
    }

    modifier onlyFromIdp() {
        //require(msg.sender == 0x5963D7FA276fA797f174752A852AbfE32Db791D6, "Invalid");
        require(1 == 1);
        _;
    }

}
