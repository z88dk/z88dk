; int adt_ListInsert(struct adt_List *list, void *item)
; 08.2005 aralbrec

XLIB adt_ListInsert
LIB ADTListInsert

.adt_ListInsert
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   call ADTListInsert
   ld hl,1
   ret c
   dec l
   ret

; enter: DE = struct adt_List *
;        BC = item *
; exit : carry reset if fail (no memory) else:
;        new item inserted before current, current points at new item
; uses : AF,BC,DE,HL
