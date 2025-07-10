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
