; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_crt0_RST08
PUBLIC _SMS_crt0_RST08_call

_SMS_crt0_RST08:               ; Restart 08h - write HL to VDP Control Port
_SMS_crt0_RST08_call:

   ld c,0xbf                   ; set VDP Control Port
   di                          ; make it interrupt SAFE
   out (c),l
   out (c),h
   ei
   ret
