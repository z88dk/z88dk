; CALLER linkage for function pointers

XLIB strncmp
LIB strncmp_callee
XREF ASMDISP_STRNCMP_CALLEE

.strncmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strncmp_callee + ASMDISP_STRNCMP_CALLEE

