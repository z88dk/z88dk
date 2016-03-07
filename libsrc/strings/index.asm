; CALLER linkage for function pointers

SECTION code_clib
PUBLIC index
PUBLIC _index
EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.index
._index

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchr_callee + ASMDISP_STRCHR_CALLEE
