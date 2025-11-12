; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION bss_clib
SECTION bss_SMSlib

PUBLIC __SMSlib_MDKeysStatus
PUBLIC __SMSlib_PreviousMDKeysStatus

__SMSlib_MDKeysStatus:

   defw 0                      ; /* variables for pad handling */

__SMSlib_PreviousMDKeysStatus:

   defw 0
