// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Zaphenath} from "../src/Zaphenath.sol";
import {Role} from "../src/Role.sol";

contract ZaphenathTest is Test {
    Zaphenath public zaph;

    address rachel = address(0x1);
    address jacob = address(0x2);
    bytes32 keyId = keccak256("ego");

    function setUp() public {
        console.log("Deploying Zaphenath contract...");
        zaph = new Zaphenath();

        console.log("Creating key for Rachel...");
        vm.prank(rachel);
        zaph.createKey(keyId, bytes(unicode"Χριστός Ανέστη"), 1 days, true);

        console.log("Key created!");
    }

    function testCreateKey() public {
        bytes32 anotherKey = keccak256("eimi");

        console.log("Creating a new key for Jacob...");
        vm.prank(jacob);
        zaph.createKey(anotherKey, bytes(unicode"Αληθώς Ανέστη"), 1 days, true);

        console.log("Reading Jacob's key...");
        vm.prank(jacob);
        bytes memory data = zaph.readKey(anotherKey, jacob);
        console.log("Data read:", string(data));
        assertEq(data, bytes(unicode"Αληθώς Ανέστη"));
    }

    function testReadKeyBeforeTimeout() public {
        console.log("Rachel trying to read her own key...");
        vm.prank(rachel);
        bytes memory data = zaph.readKey(keyId, rachel);
        console.log("Read data:", string(data));
        assertEq(data, bytes(unicode"Χριστός Ανέστη"));
    }

    function testReadKeyFailsIfNotOwner() public {
        console.log("Jacob trying to read Rachel's key before timeout...");
        vm.prank(jacob);
        vm.expectRevert("Insufficient role");
        zaph.readKey(keyId, rachel);
    }

    function testPingUpdatesLastPing() public {
        console.log("Advancing time by 3 days...");
        vm.warp(block.timestamp + 3 days);

        console.log("Rachel pings her key...");
        vm.prank(rachel);
        zaph.ping(keyId, rachel);

        console.log("Reading data after ping...");
        vm.prank(rachel);
        bytes memory data = zaph.readKey(keyId, rachel);
        console.log("Data read:", string(data));
        assertEq(data, bytes(unicode"Χριστός Ανέστη"));
    }

    function testSetAndReadCustodian() public {
        console.log("Rachel assigning Jacob as Reader...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.Reader, false);

        console.log("Advancing time by 3 days...");
        vm.warp(block.timestamp + 3 days);

        console.log("Jacob attempts to read after timeout...");
        vm.prank(jacob);
        bytes memory data = zaph.readKey(keyId, rachel);
        console.log("Data read by Jacob:", string(data));
        assertEq(data, bytes(unicode"Χριστός Ανέστη"));
    }

    function testCustodianCannotPingIfNotAllowed() public {
        console.log("Rachel assigning Jacob as Writer with no ping permission...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.Writer, false);

        console.log("Jacob tries to ping (should fail)...");
        vm.prank(jacob);
        vm.expectRevert("Not authorized to ping");
        zaph.ping(keyId, rachel);
    }

    function testCustodianCanPingIfAllowed() public {
        console.log("Rachel assigning Jacob as Writer with ping permission...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.Writer, true);

        console.log("Jacob pings the key...");
        vm.prank(jacob);
        zaph.ping(keyId, rachel);

        console.log("Ping successful");
    }

    function testDeleteKey() public {
        console.log("Rachel deletes her key...");
        vm.prank(rachel);
        zaph.deleteKey(keyId, rachel);

        console.log("Verifying key was deleted...");
        vm.expectRevert("Key doesn't exist");
        zaph.readKey(keyId, rachel);
    }

    function testUpdateKey() public {
        console.log("Rachel updates key data and timeout...");
        vm.prank(rachel);
        zaph.updateKey(keyId, rachel, bytes("Soli Deo Gloria"), 2 days, true);

        console.log("Reading updated key...");
        vm.prank(rachel);
        bytes memory updated = zaph.readKey(keyId, rachel);
        console.log("New data:", string(updated));
        assertEq(updated, bytes("Soli Deo Gloria"));
    }

    function testKeyNotReadableBeforeTimeoutIfNotAllowed() public {
        console.log("Creating a key for Rachel that is NOT readable before timeout...");
        bytes32 hiddenKeyId = keccak256("mysterion");
        vm.prank(rachel);
        zaph.createKey(hiddenKeyId, bytes("Secret Before Timeout"), 1 days, false);

        console.log("Rachel tries to read it before timeout...");
        vm.prank(rachel);
        vm.expectRevert("Data not available before timeout");
        zaph.readKey(hiddenKeyId, rachel);
    }

    function testReaderCanReadAfterTimeout() public {
        console.log("Rachel sets Jacob as Reader...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.Reader, false);

        console.log("Advancing time beyond timeout...");
        vm.warp(block.timestamp + 2 days);

        console.log("Jacob reads the key...");
        vm.prank(jacob);
        bytes memory data = zaph.readKey(keyId, rachel);
        assertEq(data, bytes(unicode"Χριστός Ανέστη"));
    }

    function testWriterCanReadAfterTimeout() public {
        console.log("Rachel sets Jacob as Writer...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.Writer, false);

        console.log("Advancing time beyond timeout...");
        vm.warp(block.timestamp + 2 days);

        console.log("Jacob reads the key...");
        vm.prank(jacob);
        bytes memory data = zaph.readKey(keyId, rachel);
        assertEq(data, bytes(unicode"Χριστός Ανέστη"));
    }

    function testNoneRoleCannotRead() public {
        console.log("Rachel sets Jacob as None...");
        vm.prank(rachel);
        zaph.setCustodian(keyId, rachel, jacob, Role.None, false);

        console.log("Advance time beyond timeout...");
        vm.warp(block.timestamp + 2 days);

        console.log("Jacob tries to read with Role.None...");
        vm.prank(jacob);
        vm.expectRevert("Insufficient role");
        zaph.readKey(keyId, rachel);
    }
}
