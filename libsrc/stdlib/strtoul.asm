; CALLER linkage for function pointers

XLIB strtoul
LIB strtol_callee
XREF ASMDISP_STRTOL_CALLEE

.strtoul

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtol_callee + ASMDISP_STRTOL_CALLEE
