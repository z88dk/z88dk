; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_RegHookFirst
PUBLIC _im2_RegHookFirst

EXTERN asm_im2_RegHookFirst

.im2_RegHookFirst
._im2_RegHookFirst

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp asm_im2_RegHookFirst
