; CALLER linkage for function pointers

XLIB strlcpy

LIB strlcpy_callee
XREF ASMDISP_STRLCPY_CALLEE

.strlcpy

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp strlcpy_callee + ASMDISP_STRLCPY_CALLEE
