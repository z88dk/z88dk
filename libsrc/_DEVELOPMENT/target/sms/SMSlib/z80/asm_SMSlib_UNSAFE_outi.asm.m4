include(`z88dk.m4')

; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC asm_SMSlib_outi_block

PUBLIC asm_SMSlib_outi32
PUBLIC asm_SMSlib_outi64
PUBLIC asm_SMSlib_outi128
PUBLIC asm_SMSlib_outi256

PUBLIC l_outi_256
PUBLIC l_outi_128
PUBLIC l_outi_64
PUBLIC l_outi_32
PUBLIC l_outi_16
PUBLIC l_outi_8
PUBLIC l_outi_4
PUBLIC l_outi_2
PUBLIC l_outi_1 

defc l_outi_128 = asm_SMSlib_outi128
defc l_outi_64  = asm_SMSlib_outi64
defc l_outi_32  = asm_SMSlib_outi32
defc l_outi_16 = l_outi_32 + 32
defc l_outi_8  = l_outi_16 + 16
defc l_outi_4  = l_outi_8  +  8
defc l_outi_2  = l_outi_4  +  4
defc l_outi_1  = l_outi_2  +  2

asm_SMSlib_outi256:
l_outi_256:

   call asm_SMSlib_outi128

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
