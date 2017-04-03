; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_crt0_RST18
PUBLIC _SMS_crt0_RST18_call

_SMS_crt0_RST18:               ; Restart 18h - write HL to VDP Data Port
_SMS_crt0_RST18_call:

   ld a,l                      ; (respecting VRAM time costraints)
   out (0xbe),a                ; 11
   ld a,h                      ; 4
   sub 0                       ; 7
   nop                         ; 4 = 26 (VRAM SAFE)
   out (0xbe),a
   ret
