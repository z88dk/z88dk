; CALLER linkage for function pointers

XLIB im2_CreateGenericISRLight

LIB im2_CreateGenericISRLight_callee
XREF ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE

.im2_CreateGenericISRLight

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   ld a,b

   jp im2_CreateGenericISRLight_callee + ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE
