; void *adt_ListPrev(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListPrev
LIB ADTListPrev

.adt_ListPrev
   call ADTListPrev
   ex de,hl
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty or current pointer is before start of list, else:
;        DE = prev item before current in list
;        current pointer changed to point at prev item in list
; uses : AF,BC,DE,HL
