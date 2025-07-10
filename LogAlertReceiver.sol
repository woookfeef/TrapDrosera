// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event AnomalyDetected(address indexed origin, string reason);

    function logAnomaly(string calldata reason) external {
        emit AnomalyDetected(msg.sender, reason);
    }
}
