## Trusted Timestamping
R package for creating Trusted Timestamps.

Trusted Timestamps (tts) are created by incorperating a sha256 hash of a file or dataset into a transaction, stored on a decentralized blockchain. The transaction on the blockchain serves as a secure proof of the exact time at which that data existed.

The package makes use of the Stellar network and of a free service provided by https://stellarapi.io. The Stellar network is chosen because of fast transaction-times (between 5 and 7 seconds) and extremely low costs of transactions.  
