; void __CALLEE__ adt_StackDelete_callee(struct adt_Stack *s, void *delete)
; 09.2005, 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackDelete_callee
PUBLIC _adt_StackDelete_callee
PUBLIC asm_adt_StackDelete

EXTERN asm_adt_StackDeleteS

EXTERN _u_free

.adt_StackDelete_callee
._adt_StackDelete_callee

   pop hl
   pop de
   ex (sp),hl
   
.asm_adt_StackDelete

   push hl
   call asm_adt_StackDeleteS
   pop hl
   push hl
   call _u_free
   pop hl
   ret

