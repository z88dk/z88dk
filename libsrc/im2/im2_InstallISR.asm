; CALLER linkage for function pointers

XLIB im2_InstallISR

LIB im2_InstallISR_callee
XREF ASMDISP_IM2_INSTALLISR_CALLEE

.im2_InstallISR

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp im2_InstallISR_callee + ASMDISP_IM2_INSTALLISR_CALLEE
