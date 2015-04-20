
; BSD
; void *rawmemchr_callee(const void *mem, int c)

SECTION code_string

PUBLIC _rawmemchr_callee, l0_rawmemchr_callee

_rawmemchr_callee:

   pop af
   pop hl
   pop bc
   push af

l0_rawmemchr_callee:

   ld a,c
   
   INCLUDE "string/z80/asm_rawmemchr.asm"
