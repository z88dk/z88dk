
; void *balloc_addmem_callee(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_addmem_callee, l0_balloc_addmem_callee

EXTERN asm_balloc_addmem

_balloc_addmem_callee:

   pop af
   pop ix
   pop bc
   pop hl
   pop de
   push af

l0_balloc_addmem_callee:

   ld a,ixl

   jp asm_balloc_addmem
