// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Role} from "./Role.sol";
import {Custodian} from "./Custodian.sol";
import {KeyData} from "./KeyData.sol";

contract Zaphenath {
    mapping(bytes32 => KeyData) private keys;

    event KeyCreated(bytes32 indexed keyId, address indexed owner);
    event KeyDeleted(bytes32 indexed keyId);
    event KeyUpdated(bytes32 indexed keyId);
    event Pinged(bytes32 indexed keyId, uint256 timestamp);
    event CustodianUpdated(bytes32 indexed keyId, address indexed user, Role role, bool canPing);

    // Helper to derive full key
    function getFullKey(bytes32 keyId, address owner) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(owner, keyId));
    }

    modifier onlyOwner(bytes32 keyId, address owner) {
        bytes32 fullKey = getFullKey(keyId, owner);
        require(keys[fullKey].owner == msg.sender, "Not key owner");
        _;
    }

    modifier onlyRoleOrAbove(bytes32 keyId, address owner, Role minimumRole) {
        bytes32 fullKey = getFullKey(keyId, owner);
        Role callerRole = keys[fullKey].custodians[msg.sender].role;

        if (msg.sender == keys[fullKey].owner) {
            callerRole = Role.Owner;
        }

        require(uint8(callerRole) >= uint8(minimumRole), "Insufficient role");
        _;
    }

    modifier keyExists(bytes32 keyId, address owner) {
        require(keys[getFullKey(keyId, owner)].exists, "Key doesn't exist");
        _;
    }

    function createKey(bytes32 keyId, bytes calldata data, uint256 timeout, bool readableBeforeTimeout) external {
        bytes32 fullKey = getFullKey(keyId, msg.sender);
        require(!keys[fullKey].exists, "Key already exists");

        KeyData storage key = keys[fullKey];
        key.owner = msg.sender;
        key.data = data;
        key.timeout = timeout;
        key.readableBeforeTimeout = readableBeforeTimeout;
        key.lastPing = block.timestamp;
        key.exists = true;

        emit KeyCreated(keyId, msg.sender);
    }

    function updateKey(
        bytes32 keyId,
        address owner,
        bytes calldata newData,
        uint256 newTimeout,
        bool newReadableBeforeTimeout
    ) external onlyRoleOrAbove(keyId, owner, Role.Writer) keyExists(keyId, owner) {
        bytes32 fullKey = getFullKey(keyId, owner);
        KeyData storage key = keys[fullKey];
        key.data = newData;
        key.timeout = newTimeout;
        key.readableBeforeTimeout = newReadableBeforeTimeout;

        emit KeyUpdated(keyId);
    }

    function ping(bytes32 keyId, address owner) external keyExists(keyId, owner) {
        bytes32 fullKey = getFullKey(keyId, owner);
        KeyData storage key = keys[fullKey];
        Custodian memory custodian = key.custodians[msg.sender];

        require(msg.sender == key.owner || custodian.canPing, "Not authorized to ping");

        key.lastPing = block.timestamp;
        emit Pinged(keyId, block.timestamp);
    }

    function readKey(bytes32 keyId, address owner)
        external
        view
        keyExists(keyId, owner)
        onlyRoleOrAbove(keyId, owner, Role.Reader)
        returns (bytes memory)
    {
        bytes32 fullKey = getFullKey(keyId, owner);
        KeyData storage key = keys[fullKey];
        uint256 timeSincePing = block.timestamp - key.lastPing;

        if (timeSincePing <= key.timeout) {
            bool isOwner = owner == msg.sender;
            require(key.readableBeforeTimeout && isOwner, "Data not available before timeout");
        }

        return key.data;
    }

    function deleteKey(bytes32 keyId, address owner)
        external
        keyExists(keyId, owner)
        onlyRoleOrAbove(keyId, owner, Role.Writer)
    {
        bytes32 fullKey = getFullKey(keyId, owner);
        delete keys[fullKey];
        emit KeyDeleted(keyId);
    }

    function setCustodian(bytes32 keyId, address owner, address user, Role role, bool canPing)
        external
        keyExists(keyId, owner)
        onlyRoleOrAbove(keyId, owner, Role.Owner)
    {
        bytes32 fullKey = getFullKey(keyId, owner);
        keys[fullKey].custodians[user] = Custodian(role, canPing);
        emit CustodianUpdated(keyId, user, role, canPing);
    }

    function removeCustodian(bytes32 keyId, address owner, address user)
        external
        keyExists(keyId, owner)
        onlyRoleOrAbove(keyId, owner, Role.Owner)
    {
        bytes32 fullKey = getFullKey(keyId, owner);
        delete keys[fullKey].custodians[user];
        emit CustodianUpdated(keyId, user, Role.None, false);
    }
}
