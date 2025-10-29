
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_addmem

EXTERN asm_balloc_addmem

balloc_addmem:

   pop ix
   pop de
   pop hl
   pop bc
   dec sp
   pop af
   inc sp
   
   push af
   push bc
   push hl
   push de
   push ix

   jp asm_balloc_addmem

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_addmem
defc _balloc_addmem = balloc_addmem
ENDIF

