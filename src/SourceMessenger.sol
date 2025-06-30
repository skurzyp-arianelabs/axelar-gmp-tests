// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import "../lib/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract SourceMessenger is AxelarExecutable {
    IAxelarGasService public gasReceiver;

    constructor(address gateway_, address gasReceiver_) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
    }

    function sendMessage(string calldata destChain, string calldata dest, string calldata message) external payable {
        bytes memory payload = abi.encode(message);
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this), destChain, dest, payload, msg.sender
        );
        gateway.callContract(destChain, dest, payload);
    }
}
