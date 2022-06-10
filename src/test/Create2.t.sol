// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import {Create2} from "../Create2.sol";
import "samples/Samples.sol";

contract Create2Test is Test {
  using Create2 for address;

  function testCreate2Address(address parent, uint salt) public {
    if (parent == address(0)) {
      return;
    }
    address created = Create2.create2(salt, type(Empty).creationCode);
    assertEq(address(this).create2Address(salt, type(Empty).creationCode), created);
  }

  function testDoubleCreate2(uint salt) public {
    bytes memory text = type(Empty).creationCode;
    Create2.create2(salt, text);

    assertEq(Create2.create2(salt, text), address(0));
  }

  function testGasCreate2Empty(uint salt) public {
    Create2.create2(salt, type(Empty).creationCode);
  }
  function testGasCreate2Identity(uint salt) public {
    Create2.create2(salt, type(Identity).creationCode);
  }
  function testGasCreate2Add(uint salt) public {
    Create2.create2(salt, type(Add).creationCode);
  }
  function testGasCreate2Sub(uint salt) public {
    Create2.create2(salt, type(Sub).creationCode);
  }
  function testGasCreate2ReturnEth(uint salt) public {
    Create2.create2(salt, type(ReturnEth).creationCode);
  }

  function testCreate2Text(uint salt, bytes calldata text) public {
    address created = Create2.create2Text(salt, text);

    if (!Create2.hasBadText(text)) {
      assertTrue(created != address(0));
      assertEq0(text, created.code);
    }
  }
}
