
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

XDEF balloc_addmem

balloc_addmem:

   pop af
   pop de
   pop hl
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   push hl
   push de
   push af
   
   exx
   ld a,c
   exx

   INCLUDE "../../z80/asm_balloc_addmem.asm"
