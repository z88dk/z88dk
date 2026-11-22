; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_crt0_RST18

_SMS_crt0_RST18:               ; Restart 18h - write HL to VDP Data Port

   ld a,l                      ; (respecting VRAM time costraints)
   out (VDPDataPort),a                ; 11
   ld a,h                      ; 4
   sub 0                       ; 7
   nop                         ; 4 = 26 (VRAM SAFE)
   out (VDPDataPort),a
   ret
