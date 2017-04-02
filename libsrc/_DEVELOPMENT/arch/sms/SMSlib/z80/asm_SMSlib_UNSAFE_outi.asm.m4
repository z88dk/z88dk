include(`z88dk.m4')

; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC _outi_block

PUBLIC _outi32
PUBLIC _outi64
PUBLIC _outi128

_outi128:

Z88DK_FOR(`LOOP', 1, 64,
`
   outi
')

_outi64:

Z88DK_FOR(`LOOP', 1, 32,
`
   outi
')

_out32:

Z88DK_FOR(`LOOP', 1, 32,
`
   outi
')

_outi_block:

   ret
