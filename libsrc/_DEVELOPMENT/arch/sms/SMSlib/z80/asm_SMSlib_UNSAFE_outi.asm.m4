include(`z88dk.m4')

; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_outi_block

PUBLIC asm_SMSlib_outi32
PUBLIC asm_SMSlib_outi64
PUBLIC asm_SMSlib_outi128

asm_SMSlib_outi128:

Z88DK_FOR(`LOOP', 1, 64,
`
   outi
')

asm_SMSlib_outi64:

Z88DK_FOR(`LOOP', 1, 32,
`
   outi
')

asm_SMSlib_outi32:

Z88DK_FOR(`LOOP', 1, 32,
`
   outi
')

asm_SMSlib_outi_block:

   ret
