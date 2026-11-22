
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_addmem_callee

EXTERN asm_balloc_addmem

balloc_addmem_callee:

   exx
   pop hl
   exx
   pop de
   pop hl
   pop bc
   dec sp
   pop af
   inc sp
   exx
   push hl
   exx

   jp asm_balloc_addmem

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_addmem_callee
defc _balloc_addmem_callee = balloc_addmem_callee
ENDIF

