
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_addmem

EXTERN asm_balloc_addmem

_balloc_addmem:

   exx
   pop bc
   exx
   dec sp
   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   dec sp
   exx
   push bc
   exx

   jp asm_balloc_addmem
