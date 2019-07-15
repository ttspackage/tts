## Trusted Timestamping
R package for creating Trusted Timestamps.

Trusted Timestamps (tts) are created by incorperating a sha256 hash of a file or dataset into a transaction, stored on a decentralized blockchain. The transaction on the blockchain serves as a secure proof of the exact time at which that data existed.

The package makes use of the Stellar network and of a free service provided by https://stellarapi.io. The Stellar network is chosen because of fast transaction-times (between 5 and 7 seconds) and extremely low costs of transactions.  

## Basic usage

Using this package is simple:

```
x <- 1

# create tts of object/dataset
url <- create_ttsObject(x)
validate_hashObject(url, x)

x <-2
validate_hashObject(url, x)
```

## 'Helper functions'
The package includes some helper functions: 

```
get_timestamp(url)
[1] "2019-07-15T18:15:36Z"

get_hash(url)
[1] bb6965c725c20f3c90df2ad1b8bf71b1544bc0bbe78cc86801940a9f3fa59e90
```

The package makes use of a free service, provided by https://stellarapi.io. This service makes it possible to make transactions and get information of previous transactions. In case you want to get the transaction on the Stellar network, you can use:

```
get_url_blockchaintransaction(url)
[1] https://stellarchain.io/tx/d288f39a5fa202275c57688aa92642f7cdfa619fdc987d9fa1bf994e88b3e63a
```
