
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

XDEF memccpy_callee:

memccpy_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af
   
   ld a,ixl
      
   INCLUDE "../../z80/asm_memccpy.asm"
