// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/DestCounter.sol";
import "../src/DestLogger.sol";
import "../src/SourceIncrementer.sol";
import "../src/SourceMessenger.sol";
import "forge-std/Script.sol";

contract DeployAxelarContracts is Script {
    struct ChainConfig {
        address gateway;
        address gasService;
    }

    mapping(string => ChainConfig) internal configs;

    constructor() {
        // Hedera
        configs["hedera"] = ChainConfig({
            gateway: 0xe432150cce91c13a887f7D836923d5597adD8E31,
            gasService: 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6
        });

        // Avalanche
        configs["avalanche"] = ChainConfig({
            gateway: 0xC249632c2D40b9001FE907806902f63038B737Ab,
            gasService: 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6
        });

        // Optimism Sepolia
        configs["optimism"] = ChainConfig({
            gateway: 0xe432150cce91c13a887f7D836923d5597adD8E31,
            gasService: 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6
        });

        // Berachain (chainId 80069)
        configs["berachain"] = ChainConfig({
            gateway: 0xe432150cce91c13a887f7D836923d5597adD8E31,
            gasService: 0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6
        });
    }

    function run() external {
        string memory targetChain = vm.envString("CHAIN");
        string memory contractPair = vm.envOr("CONTRACT_PAIR", string("counter")); // default = "counter"

        ChainConfig memory config = configs[targetChain];
        require(config.gateway != address(0), "Invalid or unsupported chain");

        vm.startBroadcast();

        if (keccak256(bytes(contractPair)) == keccak256("counter")) {
            SourceIncrementer source = new SourceIncrementer(config.gateway, config.gasService);
            DestCounter dest = new DestCounter(config.gateway);

            console.log("SourceIncrementer deployed at:", address(source));
            console.log("DestCounter deployed at:", address(dest));
        } else if (keccak256(bytes(contractPair)) == keccak256("messenger")) {
            SourceMessenger source = new SourceMessenger(config.gateway, config.gasService);
            DestLogger dest = new DestLogger(config.gateway);

            console.log("SourceMessenger deployed at:", address(source));
            console.log("DestLogger deployed at:", address(dest));
        } else {
            revert("Unsupported contract pair. Use 'counter' or 'messenger'");
        }

        vm.stopBroadcast();
    }
}
