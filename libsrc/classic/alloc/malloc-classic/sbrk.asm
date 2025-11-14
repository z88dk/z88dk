; CALLER linkage for function pointers

SECTION code_clib
PUBLIC sbrk
PUBLIC _sbrk
PUBLIC ___sbrk

EXTERN asm_sbrk

.sbrk
._sbrk
.___sbrk

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp asm_sbrk
