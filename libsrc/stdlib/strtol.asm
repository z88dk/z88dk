; CALLER linkage for function pointers

XLIB strtol
LIB strtol_callee
XREF ASMDISP_STRTOL_CALLEE

.strtol

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtol_callee + ASMDISP_STRTOL_CALLEE
