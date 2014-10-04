
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION seg_code_balloc

PUBLIC balloc_addmem

EXTERN asm_balloc_addmem

balloc_addmem:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   
   push ix
   push bc
   push hl
   push de
   push af
   
   ld a,ixl
   jp asm_balloc_addmem
