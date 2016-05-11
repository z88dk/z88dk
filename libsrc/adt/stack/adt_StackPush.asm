; int adt_StackPush(struct adt_Stack *s, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_StackPush
PUBLIC _adt_StackPush

EXTERN adt_StackPush_callee
EXTERN ASMDISP_ADT_STACKPUSH_CALLEE

.adt_StackPush
._adt_StackPush

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_StackPush_callee + ASMDISP_ADT_STACKPUSH_CALLEE
