// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Role} from "./Role.sol";

struct Custodian {
    Role role;
    bool canPing;
}
