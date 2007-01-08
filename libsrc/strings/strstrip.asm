; CALLER linkage for function pointers

XLIB strstrip
LIB strstrip_callee
XREF ASMDISP_STRSTRIP_CALLEE

.strstrip

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strstrip_callee + ASMDISP_STRSTRIP_CALLEE

