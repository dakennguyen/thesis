pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './lib/strings.sol';
import './lib/rsaverify.sol';

contract Beerclub {
    using strings for *;
    using rsaverify for *;

    address constant dnsTypes = 0xAAEf6427308fA1514173b5a5A181F281D1111fe0;

    mapping(address => RawData) private clients;

    struct RawData {
        string value;
        uint count;
    }

    struct Data {
        string attributeType;
        string attributeValue;
        string signature;
    }

    function getData(address client) public returns(bool[] memory) {
        strings.slice memory s = clients[client].value.toSlice();
        strings.slice memory space = " ".toSlice();
        strings.slice memory colon = ":".toSlice();
        strings.slice[] memory parts = new strings.slice[](s.count(space));

        bool[] memory result = new bool[](clients[client].count);

        for(uint i = 0; i < parts.length; i++) {
            parts[i] = s.split(space);
            Data memory tmp = Data(parts[i].split(colon).toString(), parts[i].split(colon).toString(), parts[i].split(colon).toString());
            result[i] = verify(tmp.attributeValue, fromHex(tmp.signature), fromHex(getPublicKey(tmp.attributeType)));
        }
        return result;
    }

    function setData(address client, string memory value, uint count) public onlyFromIdp() {
        clients[client].value = value;
        clients[client].count = count;
    }

    function verify(string memory inp, bytes memory signature, bytes memory modulus) public view returns(bool) {
        bytes32 hash = sha256(bytes(inp));
        bytes memory exponent= hex"010001";

        uint result = hash.pkcs1Sha256Verify(signature, exponent, modulus);
        return result == 0;
    }

    function getPublicKey(string memory attributeType) private returns(string memory) {
        (bool success, bytes memory result) = dnsTypes.call(abi.encodeWithSignature("getPublicKey(string)", attributeType));
        return abi.decode(result, (string));
    }

    // Convert an hexadecimal character to their value
    function fromHexChar(uint8 c) private pure returns (uint8) {
        if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
            return c - uint8(byte('0'));
        }
        if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
            return 10 + c - uint8(byte('a'));
        }
        if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
            return 10 + c - uint8(byte('A'));
        }
    }
    
    // Convert an hexadecimal string to raw bytes
    function fromHex(string memory s) private pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = byte(fromHexChar(uint8(ss[2*i])) * 16 + fromHexChar(uint8(ss[2*i+1])));
        }
        return r;
    }

    modifier onlyFromIdp() {
        //require(msg.sender == 0x5963D7FA276fA797f174752A852AbfE32Db791D6, "Invalid");
        require(1 == 1);
        _;
    }
}
