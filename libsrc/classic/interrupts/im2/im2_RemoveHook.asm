; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_RemoveHook
PUBLIC _im2_RemoveHook

EXTERN asm_im2_RemoveHook

.im2_RemoveHook
._im2_RemoveHook

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp asm_im2_RemoveHook
   
