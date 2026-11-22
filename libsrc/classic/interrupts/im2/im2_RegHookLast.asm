; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_RegHookLast
PUBLIC _im2_RegHookLast

EXTERN asm_im2_RegHookLast

.im2_RegHookLast
._im2_RegHookLast

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp asm_im2_RegHookLast
