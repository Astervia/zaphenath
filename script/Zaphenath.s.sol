// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {Zaphenath} from "../src/Zaphenath.sol";

contract ZaphenathScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Zaphenath zaph = new Zaphenath();
        console.log("Zaphenath deployed at:", address(zaph));

        vm.stopBroadcast();
    }
}
