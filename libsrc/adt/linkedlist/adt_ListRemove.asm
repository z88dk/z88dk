; void *adt_ListRemove(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListRemove
LIB ADTListRemove

.adt_ListRemove
   call ADTListRemove
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_list *
; exit : no carry = list empty or current is not INLIST else:
;        HL = item removed
;        remove current item from list, current moves to next item
; uses : AF,BC,DE,HL
