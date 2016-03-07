; CALLER linkage for function pointers

SECTION code_clib
PUBLIC memmove
PUBLIC _memmove
EXTERN memmove_callee
EXTERN ASMDISP_MEMMOVE_CALLEE

.memmove
._memmove

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memmove_callee + ASMDISP_MEMMOVE_CALLEE

