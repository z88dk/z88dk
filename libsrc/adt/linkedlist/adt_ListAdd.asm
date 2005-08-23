; int adt_ListAdd(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListAdd
LIB ADTListAdd

.adt_ListAdd
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   call ADTListAdd
   ld hl,1
   ret c
   dec l
   ret

; enter: DE = struct adt_List *
;        BC = item *
; exit : carry reset if fail (no memory) else:
;        new item inserted after current, current points at new item
; uses : AF,BC,DE,HL
