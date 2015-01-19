; CALLER linkage for function pointers

PUBLIC index
EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.index

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchr_callee + ASMDISP_STRCHR_CALLEE
