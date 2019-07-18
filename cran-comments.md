## Submission

This submission of trustedtimestamping (v0.2.4) addresses issues provided by Cran.

## Reported issues v0.2.3: 

* replace \dontrun{} by \donttest{} in your Rd-files if no API key is required. 
Reaction: Replaced, no API key is required

* ensure that your functions do not write by default or in your 
examples/vignettes/tests in the user's home filespace. E.g. create_ttsFile(file.path(tempdir(), "test.rds"))
Reaction: Functions don't write files. Timestamp is created through blockchain transaction, not by downloading some kind of certificate.

## Reported issues v0.2.2: 

* The Description field contains https://stellarapi.io. Please enclose URLs in angle brackets (<...>).

## Reported issues v0.2.1: 

* Title: please omit the redundant "R package for creating" and move the abbreviation (tts) to the Description field.
* Description: Please omit the redundant " trustedtimestamping - R package for"
* Description: Please make the latter a fully specified URL in the form <https......>.

## R CMD check results

There were no ERRORs, WARNINGs or NOTES.
