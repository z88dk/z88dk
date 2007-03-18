; CALLER linkage for function pointers

XLIB im2_CreateGenericISR

LIB im2_CreateGenericISR_callee
XREF ASMDISP_IM2_CREATEGENERICISR_CALLEE

.im2_CreateGenericISR

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,c
   
   jp im2_CreateGenericISR_callee + ASMDISP_IM2_CREATEGENERICISR_CALLEE
