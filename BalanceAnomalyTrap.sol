// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract BalanceAnomalyTrap is ITrap {
    address public constant target = 0x485176C5FfB09f06d2E2eF4e937392Fb8B6B77B9; // Укажи адрес отслеживаемого кошелька

    uint256 public constant thresholdPercent = 1;

    function collect() external view override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Not enough data");

        uint256 latest = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        if (previous == 0) return (false, "Initial run");

        uint256 diff = latest > previous ? latest - previous : previous - latest;
        uint256 percent = (diff * 100) / previous;

        if (percent >= thresholdPercent) {
            return (true, bytes(""));
        }

        return (false, bytes(""));
    }
}
