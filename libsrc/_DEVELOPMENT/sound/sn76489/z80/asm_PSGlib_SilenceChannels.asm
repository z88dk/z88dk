; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SilenceChannels

asm_PSGlib_SilenceChannels:
   ; uses : f, bc, hl
IF PSGLatchPORT
    ld a,0x9f
    out (__IO_PSG),a
    in a,(PSGLatchPort)
    ld a,0xbf
    out (__IO_PSG),a
    in a,(PSGLatchPort)
    ld a,0xdf
    out (__IO_PSG),a
    in a,(PSGLatchPort)
    ld a,0xff
    out (__IO_PSG),a
    in a,(PSGLatchPort)
    ret
ELSE
   ld hl,table_silence
   ld c,__IO_PSG

   ld b,4
   otir

   ret

table_silence:

   defb 0x9f, 0xbf, 0xdf, 0xff
ENDIF
