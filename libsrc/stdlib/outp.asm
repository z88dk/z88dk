; CALLER linkage for function pointers

SECTION code_clib
PUBLIC outp
PUBLIC _outp
EXTERN asm_outp

.outp
._outp

   pop bc
   pop de
   pop bc
   push bc
   push de
   push bc
   
   jp asm_outp

