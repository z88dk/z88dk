; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION data_lib
PUBLIC _VDPReg

_VDPReg:

   ; /* the VDP registers #0 and #1 'shadow' (initialized RAM) */
   
   defb 0x04
   defb 0x20
