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

  // @author: Adapted from https://github.com/0xsequence/sstore2/blob/b9233bcf1bbbbed37f9029e0355ac3026cd3563b/contracts/utils/Bytecode.sol
  function create2Text(uint salt, bytes memory _text) internal returns (address store) {
    store = create2(salt, abi.encodePacked(hex"63", uint32(_text.length), hex"80_60_0E_60_00_39_60_00_F3", _text));
  }

  function text(bytes memory _text) internal pure returns (bytes memory) {
    return abi.encodePacked(hex"63", uint32(_text.length), hex"80_60_0E_60_00_39_60_00_F3", _text);
  }

  function hasBadText(bytes memory _text) internal pure returns (bool has) {
    for (uint i=0;i<_text.length;i++) {
      bytes1 char = _text[i];
      if (char == 0xef) {
        return true;
      }
    }
    return false;
  }
}
