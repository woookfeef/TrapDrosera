// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract BalanceAnomalyTrap is ITrap {
    // 👇 Укажи здесь свой адрес, который будет отслеживаться
    address public constant target = 0xABcDEF1234567890abCDef1234567890AbcDeF12;
    // Порог падения баланса в процентах
    uint256 public constant dropThresholdPercent = 10;

    /// @notice Сбор данных — вызывается оффчейн ботом
    function collect() external view override returns (bytes memory) {
        // Просто возвращаем текущий баланс наблюдаемого адреса
        return abi.encode(target.balance);
    }

    /// @notice Проверка условия срабатывания — должна быть pure
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) {
            return (false, "Insufficient data");
        }

        uint256 current = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        if (previous == 0) {
            return (false, "No previous data");
        }

        if (current < previous) {
            uint256 diff = previous - current;
            uint256 percentDrop = (diff * 100) / previous;

            if (percentDrop >= dropThresholdPercent) {
                return (
                    true,
                    abi.encodePacked("Balance dropped by ", _toString(percentDrop), "%")
                );
            }
        }

        return (false, "");
    }

    /// @dev Вспомогательная функция: uint → string
    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
