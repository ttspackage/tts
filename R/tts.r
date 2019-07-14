#  tts - R package for creating Trusted Timestamps (tts)
#  Generated hashes of objects or files will be put in a blockchain transaction (on the STELLAR network)
#  Stellar transactions are executed through service available at stellarapi.io.
#
#  Copyright (C) 2019-present, Peter A. Muller
#
#  This file is part of the tts R package.
#
#  The tts R package is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Affero General Public License version 3 as
#  published by the Free Software Foundation.
#
#  The tts R package is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
#  for more details.
#
#  You should have received a copy of the GNU Affero General Public License along
#  with the tts R package. If not, see <http://www.gnu.org/licenses/>.
#
#  You can contact the author at:
#  - fst R package source repository : https://github.com/ttspackage/tts



#' @importFrom httr GET content
#' @export
httr::GET
httr::content

#' @importFrom digest digest
#' @export
digest::digest

#' @importFrom jsonlite fromJSON base64_dec
#' @export
jsonlite::fromJSON


#' create trusted timestamp of an object
#'
#' @param data any dataset or object
#'
#' @return url
#' @export
#'
#' @examples
#' create.tts.object(data)
create.tts.object <- function(data) {

  hash <- digest(data, algo=c("sha256"))

  url  <- paste("https://stellarapi.io/storehash/", hash)
  url  <- gsub(" ", "", url, fixed = TRUE)

  req  <- GET(url)
  json <- content(req, "text")
  res  <- fromJSON(json)

  url  <- paste("https://stellarapi.io/gethash/",res['transactionid'])
  url  <- gsub(" ", "", url, fixed = TRUE)

  return(url)

}

#' create trusted timestamp of a file
#'
#' @param data filename (and path, if outside working directory) of a file
#'
#' @return url
#' @export
#'
#' @examples
#' create.tts.file("test.rds")
create.tts.file <- function(data) {

  if (!is.character(data)) stop("Please specify a correct path.")

  if (!file.exists(data)) {
    print(c('File: ',data,' not found.'))
  }
  else {

    hash <- digest(data, algo="sha256", file=TRUE)

    url  <- paste("https://stellarapi.io/storehash/", hash)
    url  <- gsub(" ", "", url, fixed = TRUE)

    req  <- GET(url)
    json <- content(req, "text")
    res  <- fromJSON(json)

    url  <- paste("https://stellarapi.io/gethash/",res['transactionid'])
    url  <- gsub(" ", "", url, fixed = TRUE)

    return(url)
  }
  
}

#' create hash of an object
#'
#' @param data any dataset or object
#'
#' @return hash
#' @export
#'
#' @examples
#' create.hash.object(data)
create.hash.object <- function(data) {

  hash <- digest(data, algo=c("sha256"))
  return(hash)

}


#' create hash of a file
#'
#' @param data filename (and path, if outside working directory) of a file
#'
#' @return hash
#' @export
#'
#' @examples
#' create.hash.file("test.rds")
create.hash.file <- function(data) {

  if (!is.character(data)) stop("Please specify a correct path.")

  if (!file.exists(data)) {
    print(c('File: ',data,' not found.'))
  }
  else {

    hash <- digest(data, algo="sha256", file=TRUE)
    return(hash)
  }

}


#' retrieve hash from STELLAR network
#'
#' @param url url
#'
#' @return hash
#' @export
#'
#' @examples
#' get.hash("https://stellarapi.io/gethash/ea0ae0")
get.hash <- function(url) {

  req  <- GET(url)
  json <- content(req, "text")
  res  <- fromJSON(json)
  hex  <- unlist(res['memo-hexformat'], recursive = F, use.names = F)
  return(hex)

}

#' retrieve timestamp from STELLAR network
#'
#' @param url url
#'
#' @return GMT GMT-timestamp
#' @export
#'
#' @examples
#' get.timestamp("https://stellarapi.io/gethash/ea0ae0")
get.timestamp <- function(url) {

  req  <- GET(url)
  json <- content(req, "text")
  res  <- fromJSON(json)
  GMT  <- unlist(res['GMT-timestamp'], recursive = F, use.names = F)
  return(GMT)

}

#' retrieve url to blockchain transaction on STELLAR network
#'
#' @param url url
#'
#' @return url url to blockchain transaction
#' @export
#'
#' @examples
#' get.url.blockchaintransaction("https://stellarapi.io/gethash/ea0ae0")
get.url.blockchaintransaction <- function(url) {

  req  <- GET(url)
  json <- content(req, "text")
  res  <- fromJSON(json)
  url  <-  unlist(res['stellar-link'], recursive = F, use.names = F)
  return(url)

}


#' validate hash of an object (created on the fly) with hash in transaction on STELLAR network
#'
#' @param url url
#' @param data any data/object
#'
#' @return res result of validation
#' @export
#'
#' @examples
#' validate.objecthash("https://stellarapi.io/gethash/ea0ae0", data)
validate.objecthash <- function(url, data) {

  req          <- GET(url)
  json         <- content(req, "text")
  res          <- fromJSON(json)
  hashonthefly <- digest(data, algo=c("sha256"))
  hash         <- res['memo-hexformat']

  if(hashonthefly == hash){
    res <- "correct"
  }
  else {
    res <- "not correct"
  }

  return(res)
}


#' validate hash of a file (created on the fly) with hash in transaction on STELLAR network
#'
#' @param url url
#' @param data filename (and path, if outside working directory) of a file
#'
#' @return res result of validation
#' @export
#'
#' @examples
#' validate.filehash("https://stellarapi.io/gethash/ea0ae0", "test.rds")
validate.filehash <- function(url, data) {

  if (!is.character(data)) stop("Please specify a correct path.")

  if (!file.exists(data)) {
    print(c('File: ',data,' not found.'))
  }
  else {

    req          <- GET(url)
    json         <- content(req, "text")
    res          <- fromJSON(json)
    hashonthefly <- digest(data, algo="sha256", file=TRUE)
    hash         <- res['memo-hexformat']

    if(hashonthefly == hash){
      res <- "correct"
    }
    else {
      res <- "not correct"
    }

    return(res)

  }
}



#' convert hash as presented on STELLAR network (base64 encoded) to standard hexadecimal value
#'
#' @param data base64 encoded hash
#'
#' @return hex hexadecimal hash
#' @export
#'
#' @examples
#' convert.stellarhash("KMVvhSYRAquk3lPpzljU4SytQSawsTz1aeB+PoKFaf0=")
convert.stellarhash <- function(data) {

  dec <- base64_dec(data)
  hex <- paste( unlist(dec), collapse='')

  return(hex)

}
