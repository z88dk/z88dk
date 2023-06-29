; CALLER linkage for function pointers

SECTION code_clib
PUBLIC outp
PUBLIC _outp
PUBLIC ___outp
EXTERN asm_outp

.outp
._outp
.___outp

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp asm_outp

