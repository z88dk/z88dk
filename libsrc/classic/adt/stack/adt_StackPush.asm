; int adt_StackPush(struct adt_Stack *s, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_StackPush
PUBLIC _adt_StackPush

EXTERN asm_adt_StackPush

.adt_StackPush
._adt_StackPush

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_StackPush
