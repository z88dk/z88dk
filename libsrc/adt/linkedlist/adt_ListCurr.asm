; void *adt_ListCurr(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListCurr
LIB ADTListCurr

.adt_ListCurr
   call ADTListCurr
   ex de,hl
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty or current points outside list, else:
;        DE = current item in list
; uses : AF,DE,HL
