; CALLER linkage for function pointers

XLIB strnicmp
LIB strnicmp_callee
XREF ASMDISP_STRNICMP_CALLEE

.strnicmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strnicmp_callee + ASMDISP_STRNICMP_CALLEE

