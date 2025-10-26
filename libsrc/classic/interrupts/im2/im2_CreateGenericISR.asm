; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_CreateGenericISR
PUBLIC _im2_CreateGenericISR

EXTERN asm_im2_CreateGenericISR

.im2_CreateGenericISR
._im2_CreateGenericISR

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,c
   
   jp asm_im2_CreateGenericISR
