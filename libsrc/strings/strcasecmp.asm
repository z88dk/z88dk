; CALLER linkage for function pointers

XLIB strcasecmp
LIB stricmp_callee
XREF ASMDISP_STRICMP_CALLEE

.strcasecmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp_callee + ASMDISP_STRICMP_CALLEE
