; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strchr
PUBLIC _strchr
EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.strchr
._strchr

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchr_callee + ASMDISP_STRCHR_CALLEE

