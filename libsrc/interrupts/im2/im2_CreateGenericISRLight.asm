; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_CreateGenericISRLight
PUBLIC _im2_CreateGenericISRLight

EXTERN im2_CreateGenericISRLight_callee
EXTERN ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE

.im2_CreateGenericISRLight
._im2_CreateGenericISRLight

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,c

   jp im2_CreateGenericISRLight_callee + ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE
