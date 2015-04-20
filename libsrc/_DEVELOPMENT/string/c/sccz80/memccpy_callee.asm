
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_string

PUBLIC memccpy_callee, l0_memccpy_callee

memccpy_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

l0_memccpy_callee:

   ld a,ixl
      
   INCLUDE "string/z80/asm_memccpy.asm"
