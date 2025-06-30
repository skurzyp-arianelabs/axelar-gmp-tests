// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract DestLogger is AxelarExecutable {
    string public lastMessage;

    event MessageReceived(string message);

    constructor(address gateway_) AxelarExecutable(gateway_) {}

    function _execute(string calldata, string calldata, bytes calldata payload) internal override {
        string memory message = abi.decode(payload, (string));
        lastMessage = message;
        emit MessageReceived(message);
    }
}
