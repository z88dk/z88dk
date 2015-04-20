
; void *memcpy_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_string

PUBLIC _memcpy_callee

_memcpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_memcpy.asm"
