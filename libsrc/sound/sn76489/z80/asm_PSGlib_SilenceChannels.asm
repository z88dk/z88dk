; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "../sn76489.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SilenceChannels

asm_PSGlib_SilenceChannels:
   ; uses : f, bc, hl
IF SN76489_HAS_LATCH_PORT
    ld a,0x9f
    out (PSGPort),a
    in a,(PSGLatchPort)
    ld a,0xbf
    out (PSGPort),a
    in a,(PSGLatchPort)
    ld a,0xdf
    out (PSGPort),a
    in a,(PSGLatchPort)
    ld a,0xff
    out (PSGPort),a
    in a,(PSGLatchPort)
    ret
ELSE
   ld hl,table_silence
   ld c,PSGPort

   ld b,4
   otir

   ret

table_silence:

   defb 0x9f, 0xbf, 0xdf, 0xff
ENDIF
