
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_alloc_balloc

PUBLIC balloc_addmem_callee

balloc_addmem_callee:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   push af
   
   ld a,ixl
   
   INCLUDE "alloc/balloc/z80/asm_balloc_addmem.asm"
