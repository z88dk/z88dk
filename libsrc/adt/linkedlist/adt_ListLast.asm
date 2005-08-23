; void *adt_ListLast(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListLast
LIB ADTListLast

.adt_ListLast
   call ADTListLast
   ex de,hl
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty, else:
;        DE = item at end of list
;        current pointer changed to point at last item in list
; uses : AF,BC,DE,HL
