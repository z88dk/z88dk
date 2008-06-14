; CALLER linkage for function pointers

XLIB strlcat

LIB strlcat_callee
XREF ASMDISP_STRLCAT_CALLEE

.strlcat

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strlcat_callee + ASMDISP_STRLCAT_CALLEE
