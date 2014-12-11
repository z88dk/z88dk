
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_string

PUBLIC _memccpy

_memccpy:

   pop af
   pop de
   pop hl
   pop ix
   pop bc
   
   push bc
   push ix
   push hl
   push de
   push af
   
   ld a,ixl
   
   INCLUDE "string/z80/asm_memccpy.asm"
