// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import "../lib/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract SourceIncrementer is AxelarExecutable {
    IAxelarGasService public gasReceiver;

    constructor(address gateway_, address gasReceiver_) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
    }

    function increment(string calldata destChain, string calldata dest, uint256 amount) external payable {
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this), destChain, dest, abi.encode(amount), msg.sender
        );
        gateway.callContract(destChain, dest, abi.encode(amount));
    }
}
