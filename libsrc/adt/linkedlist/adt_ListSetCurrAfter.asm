; void __FASTCALL__ adt_ListSetCurrAfter(struct adt_List *list)
; 11.2006 aralbrec

XLIB adt_ListSetCurrAfter

; enter: hl = struct adt_List*

.adt_ListSetCurrAfter
   inc hl
   inc hl
   ld (hl),2               ; indicate current pointer points after end of list
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0               ; current pointer = 0
   ret
   