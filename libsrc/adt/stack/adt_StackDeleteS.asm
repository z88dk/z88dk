; void adt_StackDeleteS(struct adt_Stack *s, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_StackDeleteS
PUBLIC _adt_StackDeleteS

EXTERN adt_StackDeleteS_callee
EXTERN ASMDISP_ADT_STACKDELETES_CALLEE

.adt_StackDeleteS
._adt_StackDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_StackDeleteS_callee + ASMDISP_ADT_STACKDELETES_CALLEE
