; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_CreateGenericISRLight
PUBLIC _im2_CreateGenericISRLight

EXTERN asm_im2_CreateGenericISRLight

.im2_CreateGenericISRLight
._im2_CreateGenericISRLight

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,c

   jp asm_im2_CreateGenericISRLight
