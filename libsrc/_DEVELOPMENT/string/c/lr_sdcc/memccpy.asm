
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

XDEF memccpy

memccpy:

   pop af
   pop bc
   exx
   pop bc
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push bc
   exx
   push bc
   push af
   
   exx
   ld a,c
   exx
   
   INCLUDE "../../z80/asm_memccpy.asm"
