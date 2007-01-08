; CALLER linkage for function pointers

XLIB strrchr
LIB strrchr_callee
XREF ASMDISP_STRRCHR_CALLEE

.strrchr

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp strrchr_callee + ASMDISP_STRRCHR_CALLEE

