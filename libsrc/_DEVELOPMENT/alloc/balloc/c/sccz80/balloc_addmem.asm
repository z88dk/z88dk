
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_addmem

EXTERN l0_balloc_addmem_callee

balloc_addmem:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   
   push hl
   push bc
   push hl
   push de
   push af
   
   jp l0_balloc_addmem_callee
