# BalanceAnomalyTrap
Balance Anomaly Trap — Drosera Trap SERGEANT 

🌍 Objective

Create a functional and deployable Drosera trap that:

Monitors ETH balance anomalies of a specific wallet,

Uses the standard collect() / shouldRespond() interface,

Triggers a response when balance deviation exceeds a given threshold (e.g., 1%),

Integrates with a separate alert contract to handle responses.

🚧 Problem

Ethereum wallets involved in DAO treasury, DeFi protocol management, or vesting operations must maintain a consistent balance. Any unexpected change — loss or gain — could indicate compromise, human error, or exploit.

Solution: Monitor ETH balance of a wallet across blocks. Trigger a response if there's a significant deviation in either direction.

Trap Logic Summary

Trap Contract: BalanceAnomalyTrap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external view returns (bool, bytes memory);
}

contract BalanceAnomalyTrap is ITrap {
    address public constant target = 0xABcDEF1234567890abCDef1234567890AbcDeF12;
    uint256 public constant thresholdPercent = 1;

    function collect() external override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    function shouldRespond(bytes[] calldata data) external view override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Insufficient data");

        uint256 current = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        uint256 diff = current > previous ? current - previous : previous - current;
        uint256 percent = (diff * 100) / previous;

        if (percent >= thresholdPercent) {
            return (true, "");
        }

        return (false, "");
    }
}


Response Contract: LogAlertReceiver.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event Alert(string message);

    function logAnomaly(string calldata message) external {
        emit Alert(message);
    }
}



✨ What It Solves

Detects suspicious ETH flows from monitored addresses,

Provides an automated alerting mechanism,

Can integrate with automation logic (e.g., freezing funds, emergency DAO alerts).



Deployment & Setup Instructions

1. Deploy Contracts (e.g., via Foundry)
forge create src/BalanceAnomalyTrap.sol:BalanceAnomalyTrap \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...

forge create src/LogAlertReceiver.sol:LogAlertReceiver \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...

2. Update drosera.toml

[traps.mytrap]
path = "out/BalanceAnomalyTrap.sol/BalanceAnomalyTrap.json"
response_contract = "<LogAlertReceiver address>"
response_function = "logAnomaly(string)"

3. DROSERA_PRIVATE_KEY=0x... drosera apply

✅ Testing the Trap

Send ETH to/from target address on Ethereum Hoodi testnet.

Wait 1 block.

Observe logs from Drosera operator:

ShouldRespond='true'

Extensions & Improvements

Allow dynamic threshold setting via setter,

Track ERC-20 balances in addition to native ETH,

Chain multiple traps using a unified collector.


📅 Date & Author

First created: July 10, 2025

Author: Danzel && Profit_Nodes (@Danzeliti)

