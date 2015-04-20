
; void *memccpy_callee(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_string

PUBLIC _memccpy_callee, l0_memccpy_callee

_memccpy_callee:

   pop af
   pop de
   pop hl
   exx
   pop bc
   exx
   pop bc
   push af

l0_memccpy_callee:

   exx
   ld a,c
   exx
   
   INCLUDE "string/z80/asm_memccpy.asm"
