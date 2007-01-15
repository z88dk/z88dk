; CALLER linkage for function pointers

XLIB realloc

LIB realloc_callee
XREF ASMDISP_REALLOC_CALLEE

.realloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp realloc_callee + ASMDISP_REALLOC_CALLEE
