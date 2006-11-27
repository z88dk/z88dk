; void adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n)
; 11.2006 aralbrec

XLIB ADTListSetCurr

; enter: HL = struct adt_List*
;        DE = struct adt_ListNode*, if 0 no changes done

.ADTListSetCurr
   ld a,d                     ; if new current pointer = 0, do not change anything
   or e
   ret z
   
   inc hl
   inc hl
   ld (hl),1                  ; current will point inside list
   inc hl
   ld (hl),d                  ; store current pointer
   inc hl
   ld (hl),e
   ret
