; void adt_StackDeleteS(struct adt_Stack *s, void *delete)
; CALLER linkage for function pointers

XLIB adt_StackDeleteS

LIB adt_StackDeleteS_callee
XREF ASMDISP_ADT_STACKDELETES_CALLEE

.adt_StackDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_StackDeleteS_callee + ASMDISP_ADT_STACKDELETES_CALLEE
