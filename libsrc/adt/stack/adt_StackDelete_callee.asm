; void __CALLEE__ adt_StackDelete_callee(struct adt_Stack *s, void *delete)
; 09.2005, 11.2006 aralbrec

XLIB adt_StackDelete_callee
XDEF ASMDISP_ADT_STACKDELETE_CALLEE

LIB adt_StackDeleteS_callee
XREF ASMDISP_ADT_STACKDELETES_CALLEE

XREF _u_free

.adt_StackDelete_callee

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

DEFC ASMDISP_ADT_STACKDELETE_CALLEE = asmentry - adt_StackDelete_callee
