; int adt_StackPush(struct adt_Stack *s, void *item)
; CALLER linkage for function pointers

PUBLIC adt_StackPush

EXTERN adt_StackPush_callee
EXTERN ASMDISP_ADT_STACKPUSH_CALLEE

.adt_StackPush

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_StackPush_callee + ASMDISP_ADT_STACKPUSH_CALLEE
