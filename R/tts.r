#  trustedtimestamping - R package for creating Trusted Timestamps (tts)
#  Trusted Timestamps (tts) are created by submitting a sha256 hash of the file or dataset into a transaction on the decentralized blockchain (Stellar network).
#  The package makes use of a free service provided by https://stellarapi.io.
#
#  Copyright (C) 2019-present, Peter A. Muller
#
#  This file is part of the trustedtimestamping R package.
#
#  The trustedtimestamping R package is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Affero General Public License version 3 as
#  published by the Free Software Foundation.
#
#  The trustedtimestamping R package is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
#  for more details.
#
#  You should have received a copy of the GNU Affero General Public License along
#  with the trustedtimestamping R package. If not, see <http://www.gnu.org/licenses/>.
#
#  You can contact the author at:
#  - trustedtimestamping R package source repository : https://github.com/ttspackage/tts



#' @importFrom httr GET content use_proxy verbose
#' @export
httr::GET
httr::content
httr::use_proxy
httr::verbose

#' @importFrom digest digest
#' @export
digest::digest

#' @importFrom jsonlite fromJSON base64_dec validate
#' @export
jsonlite::fromJSON


#' Create trusted timestamp of an object/dataset
#'
#' @param data any dataset or object
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return url
#' @export
#'
#' @examples
#' \donttest{
#' create_ttsObject(data)
#' }
create_ttsObject <- function(data, proxy_ip=NULL, proxy_port=NULL) {

  if (!exists(deparse(substitute(data)))) {
    stop("object '",deparse(substitute(data)),"' does not exist")
  }

  hash <- digest(data, algo=c("sha256"))

  url  <- paste("https://stellarapi.io/storehash/", hash)
  url  <- gsub(" ", "", url, fixed = TRUE)

  if (!is.null(proxy_ip)) {
    req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
  }
  else {
    req <- GET(url)
  }

  json <- content(req, "text")
  res  <- fromJSON(json)

  if (res['code'] == 200) {

    url  <- paste("https://horizon.stellar.org/transactions/",res['transactionid'])
    url  <- gsub(" ", "", url, fixed = TRUE)
  }
  else {
    stop("Something went wrong. Errormessage: ",res['message'])
  }

  return(url)

}

#' Create trusted timestamp of a file
#'
#' @param path filename (and path, if outside working directory)
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return url
#' @export
#'
#' @examples
#' \donttest{
#' create_ttsFile("test.rds")
#' }
create_ttsFile <- function(path, proxy_ip=NULL, proxy_port=NULL) {

  if (!is.character(path)) stop("Please specify a correct path.")

  if (!file.exists(path)) {
    stop("File: '",path,"' not found.")
  }
  else {

    hash <- digest(path, algo="sha256", file=TRUE)

    url  <- paste("https://stellarapi.io/storehash/", hash)
    url  <- gsub(" ", "", url, fixed = TRUE)

    if (!is.null(proxy_ip)) {
      req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
    }
    else {
      req <- GET(url)
    }

    json <- content(req, "text")
    res  <- fromJSON(json)

    if (res['code'] == 200) {

      url  <- paste("https://horizon.stellar.org/transactions/",res['transactionid'])
      url  <- gsub(" ", "", url, fixed = TRUE)
    }
    else {
      stop("Something went wrong. Errormessage: ",res['message'])
    }

    return(url)
  }
}


#' Create sha256 hash of an object/dataset
#'
#' @param data any dataset or object
#'
#' @return hash
#' @export
#'
#' @examples
#' \donttest{
#' create_hashObject(data)
#' }
create_hashObject <- function(data) {

  if (!exists(deparse(substitute(data)))) {
    stop("object '",deparse(substitute(data)),"' does not exist")
  }

  hash <- digest(data, algo=c("sha256"))
  return(hash)

}


#' Create sha256 hash of a file
#'
#' @param path filename (and path, if outside working directory) of a file
#'
#' @return hash
#' @export
#'
#' @examples
#' \donttest{
#' create_hashFile("test.rds")
#' }
create_hashFile <- function(path) {

  if (!is.character(path)) stop("Please specify a correct path.")

  if (!file.exists(path)) {
    stop("File: '",path,"' not found.")
  }
  else {

    hash <- digest(path, algo="sha256", file=TRUE)
    return(hash)
  }

}


#' Retrieve hash from STELLAR network
#'
#' @param url url
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return hash
#' @export
#'
#' @examples
#' \donttest{
#' get_hash("https://horizon.stellar.org/transactions/ea0ae0etc")
#' }
get_hash <- function(url, proxy_ip=NULL, proxy_port=NULL) {

  #get information direct from horizon.stellar.org
  url  <- gsub("https://stellarapi.io/gethash/", "https://horizon.stellar.org/transactions/", url, fixed = TRUE)

  if (!is.null(proxy_ip)) {
    req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
  }
  else {
    req <- GET(url)
  }

  json <- content(req, "text")

  if (validate(json)==FALSE) {
    stop("horizon.stellar.org returned an unknown error")
  }

  res  <- fromJSON(json)
  dec  <- unlist(res['memo'], recursive = FALSE, use.names = FALSE)

  if (length(dec) < 1) { stop("The resource at the url requested was not found.") }

  hex <- base64_dec(dec)
  hex <- paste( unlist(hex), collapse='')

  return(hex)

}


#' Retrieve timestamp from STELLAR network
#'
#' @param url url
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return GMT GMT-timestamp
#' @export
#'
#' @examples
#' \donttest{
#' get_timestamp("https://horizon.stellar.org/transactions/ea0ae0etc")
#' }
get_timestamp <- function(url, proxy_ip=NULL, proxy_port=NULL) {

  #get information direct from horizon.stellar.org
  url  <- gsub("https://stellarapi.io/gethash/", "https://horizon.stellar.org/transactions/", url, fixed = TRUE)

  if (!is.null(proxy_ip)) {
    req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
  }
  else {
    req <- GET(url)
  }

  json <- content(req, "text")

  if (validate(json)==FALSE) {
    stop("horizon.stellar.org returned an unknown error")
  }

  res  <- fromJSON(json)

  GMT  <- unlist(res['created_at'], recursive = FALSE, use.names = FALSE)

  if (is.null(GMT)) {
    stop("The resource at the url requested was not found.")
  }

  return(GMT)

}


#' Get url of the transaction on STELLAR network (stellarchain.io (non-json))
#'
#' @param url url
#'
#' @return url url of blockchain transaction
#' @export
#'
#' @examples
#' \donttest{
#' get_url_blockchaintransaction("https://horizon.stellar.org/transactions/ea0ae0etc")
#' }
get_url_blockchaintransaction <- function(url) {

  #get information direct from horizon.stellar.org
  url  <- gsub("https://stellarapi.io/gethash/", "https://horizon.stellar.org/transactions/", url, fixed = TRUE)

  url  <- gsub("https://horizon.stellar.org/transactions/", "https://stellarchain.io/tx/", url, fixed = TRUE)

  return(url)

}


#' Validate hash of an object/dataset (created on the fly) with hash on STELLAR network
#' p.s. stellar transactions take between 5-7 seconds. If you validate to soon after creating a timestamp, it will fail...
#'
#' @param url url
#' @param data any dataset or object
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return res result of validation
#' @export
#'
#' @examples
#' \donttest{
#' validate_hashObject("https://horizon.stellar.org/transactions/ea0ae0etc", data)
#' }
validate_hashObject <- function(url, data, proxy_ip=NULL, proxy_port=NULL) {

  #get information direct from horizon.stellar.org
  url  <- gsub("https://stellarapi.io/gethash/", "https://horizon.stellar.org/transactions/", url, fixed = TRUE)

  if (!exists(deparse(substitute(data)))) {
    stop("object '",deparse(substitute(data)),"' does not exist")
  }

  if (!is.null(proxy_ip)) {
    req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
  }
  else {
    req <- GET(url)
  }

  json         <- content(req, "text")

  if (validate(json)==FALSE) {
    stop("horizon.stellar.org returned an unknown error")
  }

  res  <- fromJSON(json)

  dec  <- unlist(res['memo'], recursive = FALSE, use.names = FALSE)

  if (length(dec) < 1) { stop("The resource at the url requested was not found.") }

  hex  <- base64_dec(dec)
  hash <- paste( unlist(hex), collapse='')

  hashonthefly <- digest(data, algo=c("sha256"))

  if(hashonthefly == hash){
    res <- "correct"
  }
  else {
    res <- "not correct"
  }

  return(res)

}


#' Validate hash of a file (created on the fly) with hash on STELLAR network
#' p.s. stellar transactions take between 5-7 seconds. If you validate to soon after creating a timestamp, it will fail...
#'
#' @param url url
#' @param path filename (and path, if outside working directory)
#' @param proxy_ip if needed, provide proxy ip
#' @param proxy_port if needed, provide proxy port
#'
#' @return res result of validation
#' @export
#'
#' @examples
#' \donttest{
#' validate_hashFile("https://horizon.stellar.org/transactions/ea0ae0etc", "test.rds")
#' }
validate_hashFile <- function(url, path, proxy_ip=NULL, proxy_port=NULL) {

  #get information direct from horizon.stellar.org
  url  <- gsub("https://stellarapi.io/gethash/", "https://horizon.stellar.org/transactions/", url, fixed = TRUE)

  if (!is.character(path)) stop("Please specify a correct path.")

  if (!file.exists(path)) {
    stop("File: '",path,"' not found.")
  }
  else {

    if (!is.null(proxy_ip)) {
      req <- GET(url, use_proxy(proxy_ip, proxy_port),verbose(data_out = FALSE, data_in = FALSE, info = FALSE, ssl = FALSE))
    }
    else {
      req <- GET(url)
    }

    json         <- content(req, "text")

    if (validate(json)==FALSE) {
      stop("horizon.stellar.org returned an unknown error")
    }

    res  <- fromJSON(json)

    dec  <- unlist(res['memo'], recursive = FALSE, use.names = FALSE)

    if (length(dec) < 1) { stop("The resource at the url requested was not found.") }

    hex  <- base64_dec(dec)
    hash <- paste( unlist(hex), collapse='')

    hashonthefly <- digest(path, algo="sha256", file=TRUE)

    if(hashonthefly == hash){
      res <- "correct"
    }
    else {
      res <- "not correct"
    }

    return(res)
  }

}


#' Convert hash on STELLAR network (base64 encoded) to standard hexadecimal value
#'
#' @param data base64 encoded hash
#'
#' @return hex hexadecimal hash
#' @export
#'
#' @examples
#' \donttest{
#' convert_stellarHash("KMVvhSYRAquk3lPpzljU4SytQSawsTz1aeB+PoKFaf0=")
#' }
convert_stellarHash <- function(data) {

  dec <- base64_dec(data)
  hex <- paste( unlist(dec), collapse='')

  return(hex)

}
