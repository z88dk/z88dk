; void adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n)
; 11.2006 aralbrec

XLIB adt_ListSetCurr
LIB ADTListSetCurr

.adt_ListSetCurr
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp ADTListSetCurr
