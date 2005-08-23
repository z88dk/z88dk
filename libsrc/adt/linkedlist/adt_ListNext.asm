; void *adt_ListNext(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListNext
LIB ADTListNext

.adt_ListNext
   call ADTListNext
   ex de,hl
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty or current pointer is past end of list, else:
;        DE = next item after current in list
;        current pointer changed to point at next item in list
; uses : AF,BC,DE,HL

