
; void *balloc_addmem_callee(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_alloc_balloc

PUBLIC _balloc_addmem_callee, l0_balloc_addmem_callee

_balloc_addmem_callee:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop hl
   pop de
   push af

l0_balloc_addmem_callee:

   exx   
   ld a,c
   exx

   INCLUDE "alloc/balloc/z80/asm_balloc_addmem.asm"
