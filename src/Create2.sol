// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.13;

library Create2 {
  function create2Address(address parent, uint salt, bytes memory _text) internal pure returns (address) {
    return address(
        uint160(
          uint256(
            keccak256(
              abi.encodePacked(
                bytes1(0xff),
                parent,
                salt,
                keccak256(abi.encodePacked(_text))
              )
            )
          )
        )
    );
  }

  function create2(uint salt, bytes memory _text) internal returns (address store) {
    assembly {
      store := create2(0, add(_text, 0x20), mload(_text), salt)
    }
  }
}
