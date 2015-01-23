; CALLER linkage for function pointers

PUBLIC lseek

EXTERN lseek_callee
EXTERN ASMDISP_LSEEK_CALLEE

.lseek

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   push hl
   push hl
   push hl
   push hl
   push af
   
   jp lseek_callee + ASMDISP_LSEEK_CALLEE
