// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event Alert(string message, uint256 totalAlerts);

    uint256 public totalAlerts;

    function logAnomaly(string calldata message) external {
        totalAlerts++;
        emit Alert(message, totalAlerts);
    }
}
