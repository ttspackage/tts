## Trusted Timestamping
R package for creating Trusted Timestamps.

Trusted Timestamps (tts) are created by incorperating a sha256 hash of a file or dataset into a transaction, stored on a decentralized blockchain. The transaction on the blockchain serves as a secure proof of the exact time at which that data existed.

The package makes use of the Stellar network and of a free service provided by https://stellarapi.io. The Stellar network is chosen because of fast transaction-times (between 5 and 7 seconds) and extremely low costs of transactions.  

## Basic usage

Using this package is simple:

```
x <- 1

# create tts of object/dataset, it takes about 6 seconds to make a transaction
url <- create_ttsObject(x)

# Compare the hash on the Stellar network with the hash generated 'on the fly'
# Take note: conformation proces on Stellar takes 6 seconds. If you validate when the transaction is not confirmed, 
# the result will be 'not correct'
validate_hashObject(url, x)

x <-2
validate_hashObject(url, x)
```

Remember to store the provided url for later use! 

## 'Helper functions'
The package includes some helper functions: 

```
get_timestamp(url)
[1] "2019-07-15T18:15:36Z"

get_hash(url)
[1] "744e41f7d7e1f05bd29229a944ee598b94d593aec4c012e50bdeb63a1cd0b6b7"
```

The package makes use of a free service, provided by https://stellarapi.io. This service makes it possible to make transactions and get information of previous transactions. In case you want to get the transaction on the Stellar network, you can use:

```
get_url_blockchaintransaction(url)
[1] "https://stellarchain.io/tx/d288f39a5fa202275c57688aa92642f7cdfa619fdc987d9fa1bf994e88b3e63a"
```

The provided url shows all information of the transaction on the Stellar network. This serves as a secure proof of the exact time at which that data existed. Be aware: Stellar stores hashes in binairy format and presents them base64 encoded. Use the following code to convert the 64encoded hash to regular hexadecimal form:

```
convert_stellarHash("dE5B99fh8FvSkimpRO5Zi5TVk67EwBLlC962OhzQtrc=")
[1] "744e41f7d7e1f05bd29229a944ee598b94d593aec4c012e50bdeb63a1cd0b6b7"
```
