
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_addmem_callee, l0_balloc_addmem_callee

EXTERN asm_balloc_addmem

balloc_addmem_callee:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   push af

l0_balloc_addmem_callee:

   ld a,ixl
   
   jp asm_balloc_addmem
