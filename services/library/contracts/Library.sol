pragma solidity ^0.5.0;

import './lib/rsaverify.sol';
import './lib/verifier.sol';

contract Library {
    using Pairing for *;
    using rsaverify for *;

    address constant idpContract = 0x6D58AE38ca510a119fb903B35B88Fd5936a33eA7;
    address constant dnsContract = 0xCE43d89aBBD54485be9a4009Cc50F47dD623aE54;

    address private owner;
    string private ipfsHash;
    mapping(address => bool) private authenticated;

    constructor() public {
        owner = msg.sender;
    }

    function isAuthenticated() public view returns(bool) {
        return authenticated[msg.sender];
    }

    function getIpfsHash() public view returns(string memory) {
        return ipfsHash;
    }

    function setIpfsHash(string memory _ipfsHash) public onlyOwner () {
        ipfsHash = _ipfsHash;
    }

    function getHashAndSignature(address addr, string memory attributeType) private returns(bytes memory, bytes memory) {
        (bool success, bytes memory result) = idpContract.call(abi.encodeWithSignature("getData(address,string)", addr, attributeType));
        require(success, "Cannot access IDP contract");
        return abi.decode(result, (bytes, bytes));
    }

    function getModulusAndExponent(string memory attributeType) private returns(bytes memory, bytes memory) {
        (bool success, bytes memory result) = dnsContract.call(abi.encodeWithSignature("getPublicKey(string)", attributeType));
        require(success, "Cannot access DNS contract");
        return abi.decode(result, (bytes, bytes));
    }

    function verifyHashSignature(string memory attributeType, uint a, uint b) private {
        bytes memory inputHash = toBytes(a * 340282366920938463463374607431768211456 + b);
        (bytes memory hash, bytes memory signature) = getHashAndSignature(msg.sender, attributeType);
        require(keccak256(inputHash) == keccak256(hash), "Hash value in proof.json is diffrent from hash value in the ledger");
        (bytes memory modulus, bytes memory exponent) = getModulusAndExponent(attributeType);
        bytes32 hash32 = bytesToBytes32(hash, 0);
        require(hash32.pkcs1Sha256Verify(signature, exponent, modulus) == 0, "Signature error");
    }

    function authenticate(uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[5] memory input) public {
        require(!authenticated[msg.sender], "You have been already authenticated");
        verifyHashSignature('name', input[0], input[1]);
        verifyHashSignature('uni', input[2], input[3]);
        require(verifyTx(a, b, c, input), "Invalid proof.json");
        authenticated[msg.sender] = true;
    }

    function toBytes(uint x) private pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
        bytes32 out;

        for (uint i = 0; i < 32; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    struct VerifyingKey {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x2df5b91ddb38909f28944fca375432a64c9e0609d8222b8564e849191bfeef1b), uint256(0x0c0f45231950ddeaf05a1e8079d3f09aa6944134ad77e5e4bfbe43247bf072ac));
        vk.b = Pairing.G2Point([uint256(0x221e032c65515e5f765f4e2ed6820ce425c29900eb55cd5b6517b15b9b1dffc4), uint256(0x272c1bacfdd393ab7a9459581cc875410e5ca7987fd9740936d5ed376172b11a)], [uint256(0x2eef533d1670f77cc4c16f766f58dba226900eb00dd131df9558ccfb0b26423a), uint256(0x1065aa2e7479d1db011eb1fec08d43c3d2e120483fd913e7cf6bf05fed2bed03)]);
        vk.gamma = Pairing.G2Point([uint256(0x25e7e96c6c1846e318fa66e76d72f5b77200df7373c79e99f6b51ac9fdf693ce), uint256(0x265b399533c94c9c4030a04157934ed932210bc0ec4c34b8cc99a460a53a4385)], [uint256(0x08f065af8f16eb61dacb1ea10321d93755d54b580538c751c3b234f885043ecc), uint256(0x2e60dbbf68be89fa81ff7ee99081e0c029f8d9828fe0d39e877c49f347285502)]);
        vk.delta = Pairing.G2Point([uint256(0x1957e199b25329d4189377cd085734a79b4d9d5e95bd60e9a7c0f52972004cd1), uint256(0x15c5d152356b25a774be46062576b423a8f53868c6cfbf665d83b1ffaeb5414c)], [uint256(0x089dbc973bb655b52c5e0fdba9f1d5f4fa14327748a96be42dc5837421797c47), uint256(0x12b2b28474ac70af425c38d9205123940c43edbe84dc4f5a8322d010638b2fa2)]);
        vk.gamma_abc = new Pairing.G1Point[](6);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x15b7995761d8921f62c90ac9f6e97abd430161b4dd977942bac6fade3eee09f7), uint256(0x1b54982ca79d49a91b5adb0c2bf0e9076ec777094db694c475dbb4845f5b61a3));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x20a7dba19310cf996d69fb3768d08742ddb2c26423e98457d28052e313af7ce0), uint256(0x2e357116a365f9a7f516518e468aab7e70df0d40803a4e07f5269e70e5474eec));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0cfb7697f0a13ccb2d75e1bc39344d81a7555159738ddca7e8bd22896d2c12ef), uint256(0x05331030df9084410428fed80b4ee424b569b36f5531e58ce733a0083ed69742));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x22e70609b7567c285a39fe9ceb43ab8058a2094cfef2cf16826da20a92cbc69a), uint256(0x204de1b37877fbbe0ab651152585f2967bd21c84f0f71980523d5ea99be6e257));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2a3cfad257c6a43fa5ef8116ef1a007e03f50b6c72548475938017c94e00e7d2), uint256(0x1f8e696c0b9ec27698c146a6bfc96ba230725f03678ac771dba5bbbb0f1f3f06));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2848cd08f98dd0b23b5d7fba5b2431393cbcfb2f667ca3709e80a598b4a050b0), uint256(0x06a6db704eb8c5a79bc62f574c7c486199868c757d9758c0b85fdb40cb67f307));
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
            proof.a, proof.b,
                Pairing.negate(vk_x), vk.gamma,
            Pairing.negate(proof.c), vk.delta,
            Pairing.negate(vk.a), vk.b)) return 1;
            return 0;
    }
    event Verified(string s);
    function verifyTx(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[5] memory input
    ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
