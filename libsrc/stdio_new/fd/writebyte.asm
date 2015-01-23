; CALLER linkage for function pointers

PUBLIC writebyte

EXTERN writebyte_callee
EXTERN ASMDISP_WRITEBYTE_CALLEE

.writebyte

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp writebyte_callee + ASMDISP_WRITEBYTE_CALLEE
