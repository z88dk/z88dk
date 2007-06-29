; CALLER linkage for function pointers

XLIB rindex
LIB strrchr_callee
XREF ASMDISP_STRRCHR_CALLEE

.rindex

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp strrchr_callee + ASMDISP_STRRCHR_CALLEE
