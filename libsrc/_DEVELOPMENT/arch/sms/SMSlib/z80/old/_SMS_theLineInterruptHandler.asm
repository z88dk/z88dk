; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION bss_lib
PUBLIC _SMS_theLineInterruptHandler

_SMS_theLineInterruptHandler:

   ; /* 'empty' line interrupt handler */
   
   defw 0
