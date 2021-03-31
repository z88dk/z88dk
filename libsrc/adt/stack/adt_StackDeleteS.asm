; void adt_StackDeleteS(struct adt_Stack *s, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_StackDeleteS
PUBLIC _adt_StackDeleteS

EXTERN asm_adt_StackDeleteS

.adt_StackDeleteS
._adt_StackDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_StackDeleteS
