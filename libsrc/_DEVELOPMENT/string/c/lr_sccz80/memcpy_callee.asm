
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)

XDEF memcpy_callee

memcpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_memcpy.asm"
