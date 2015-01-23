; CALLER linkage for function pointers

PUBLIC write

EXTERN write_callee
EXTERN ASMDISP_WRITE_CALLEE

.write

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp write_callee + ASMDISP_WRITE_CALLEE
