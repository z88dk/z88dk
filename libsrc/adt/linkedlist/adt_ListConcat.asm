; void adt_ListConcat(struct adt_List *list1, struct sp_List *list2)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListConcat
LIB ADTListConcat

.adt_ListConcat
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
   ex de,hl
   jp ADTListConcat

; enter: HL = list2, DE = list1
; exit : list1 = list1 concat list2, list2 is deleted
; uses : AF,BC,DE,HL
