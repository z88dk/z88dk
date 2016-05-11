; void __CALLEE__ adt_ListDelete_callee(struct adt_List *list, void *delete)
; /* void __FASTCALL__ (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListDelete_callee
PUBLIC _adt_ListDelete_callee
PUBLIC ASMDISP_ADT_LISTDELETE_CALLEE

EXTERN adt_ListDeleteS_callee
EXTERN ASMDISP_ADT_LISTDELETES_CALLEE

EXTERN _u_free

.adt_ListDelete_callee
._adt_ListDelete_callee

   pop bc
   pop de
   pop hl
   push bc
   
.asmentry

; enter: hl = struct adt_List *
;        de = delete with HL = item
; exit : All items in list deleted but not adt_List struct itself
;        (delete) is called once for each item in the list with
;          HL = item and stack=item
; note : not multi-thread safe
; uses : af, bc, de, hl, ix

   push hl
   call adt_ListDeleteS_callee + ASMDISP_ADT_LISTDELETES_CALLEE
   pop hl
   
   push hl
   call _u_free
   pop hl
   ret
      
DEFC ASMDISP_ADT_LISTDELETE_CALLEE = # asmentry - adt_ListDelete_callee
