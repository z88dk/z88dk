; int adt_ListAppend(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListAppend
LIB ADTListAppend

.adt_ListAppend
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   call ADTListAppend
   ld hl,1
   ret c
   dec l
   ret

; enter: DE = struct adt_List *
;        BC = item *
; exit : carry reset if fail (no memory)
;        new item appended to end of list, current points at new item
; uses : AF,BC,DE,HL
