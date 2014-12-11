
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_string

PUBLIC _memcpy

_memcpy:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_memcpy.asm"
