; void __CALLEE__ adt_StackDelete_callee(struct adt_Stack *s, void *delete)
; 09.2005, 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackDelete_callee
PUBLIC _adt_StackDelete_callee
PUBLIC ASMDISP_ADT_STACKDELETE_CALLEE

EXTERN adt_StackDeleteS_callee
EXTERN ASMDISP_ADT_STACKDELETES_CALLEE

EXTERN _u_free

.adt_StackDelete_callee
._adt_StackDelete_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

   push hl
   call adt_StackDeleteS_callee + ASMDISP_ADT_STACKDELETES_CALLEE
   pop hl
   push hl
   call _u_free
   pop hl
   ret

DEFC ASMDISP_ADT_STACKDELETE_CALLEE = # asmentry - adt_StackDelete_callee
