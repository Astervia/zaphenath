// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Custodian} from "./Custodian.sol";

struct KeyData {
    address owner;
    bytes data;
    uint256 lastPing;
    uint256 timeout;
    bool readableBeforeTimeout;
    mapping(address => Custodian) custodians;
    bool exists;
}
