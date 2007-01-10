; CALLER linkage for function pointers

XLIB div
LIB div_callee
XREF ASMDISP_DIV_CALLEE

.div

   pop af
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push af
   
   jp div_callee + ASMDISP_DIV_CALLEE

