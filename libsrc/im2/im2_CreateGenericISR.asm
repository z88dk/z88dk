; CALLER linkage for function pointers

PUBLIC im2_CreateGenericISR

EXTERN im2_CreateGenericISR_callee
EXTERN ASMDISP_IM2_CREATEGENERICISR_CALLEE

.im2_CreateGenericISR

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,c
   
   jp im2_CreateGenericISR_callee + ASMDISP_IM2_CREATEGENERICISR_CALLEE
