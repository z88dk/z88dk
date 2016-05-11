; void __CALLEE__ adt_ListSetCurr_callee(struct adt_List *list, struct adt_ListNode *n)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_ListSetCurr_callee
PUBLIC _adt_ListSetCurr_callee
PUBLIC ASMDISP_ADT_LISTSETCURR_CALLEE

.adt_ListSetCurr_callee
._adt_ListSetCurr_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

; enter: hl = struct adt_List*
;        de = struct adt_ListNode*, if MSB = 0 no changes done

   ld a,d                     ; if new current pointer has MSB 0, do not change anything
   or a
   ret z
   
   inc hl
   inc hl
   ld (hl),1                  ; current will point inside list
   inc hl
   ld (hl),d                  ; store current pointer
   inc hl
   ld (hl),e
   ret

DEFC ASMDISP_ADT_LISTSETCURR_CALLEE = # asmentry - adt_ListSetCurr_callee
