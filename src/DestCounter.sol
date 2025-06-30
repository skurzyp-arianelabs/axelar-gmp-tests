// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract DestCounter is AxelarExecutable {
    uint256 public count;

    constructor(address gateway_) AxelarExecutable(gateway_) {}

    function _execute(string calldata, string calldata, bytes calldata payload) internal override {
        uint256 inc = abi.decode(payload, (uint256));
        count += inc;
    }
}
