This is a resubmission. I fixed the DESCRIPTION file, I completed the missing 
'Value' section in the documentation, and I suppressed the message printed by 
the call to system2(). I didn't suppress the calls to cat() because these are 
messages printed when prompting the user and they should not be suppressed.


## Testing environments

- Local R-4.2.0, Windows 10
- R-4.2.0, Ubuntu 20, via Github action
- win-builder devel


## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
