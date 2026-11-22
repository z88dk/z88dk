; void adt_StackDelete(struct adt_Stack *s, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_StackDelete
PUBLIC _adt_StackDelete

EXTERN asm_adt_StackDelete

.adt_StackDelete
._adt_StackDelete

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_StackDelete