; CALLER linkage for function pointers

XLIB memmove
LIB memmove_callee
XREF ASMDISP_MEMMOVE_CALLEE

.memmove

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memmove_callee + ASMDISP_MEMMOVE_CALLEE

