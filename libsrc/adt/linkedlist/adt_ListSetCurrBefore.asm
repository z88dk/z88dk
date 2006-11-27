; void __FASTCALL__ adt_ListSetCurrBefore(struct adt_List *list)
; 11.2006 aralbrec

XLIB adt_ListSetCurrBefore

; enter: HL = struct adt_List*

.adt_ListSetCurrBefore
   inc hl
   inc hl
   ld (hl),0               ; indicate current pointer points after end of list
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0               ; current pointer = 0
   ret
   