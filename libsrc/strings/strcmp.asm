; CALLER linkage for function pointers

XLIB strcmp
LIB strcmp_callee
XREF ASMDISP_STRCMP_CALLEE

.strcmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcmp_callee + ASMDISP_STRCMP_CALLEE

