; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION bss_lib
PUBLIC _SMS_Flags

_SMS_Flags:

   ; Pause Requested = bit 0
   ; VDP Blank =  bit 7
   ; Sprite Overflow = bit 6
   ; Sprite Collision = bit 5
   
   defb 0
