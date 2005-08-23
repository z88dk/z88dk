; void __FASTCALL__ *adt_ListTrim(struct adt_List *list)
; 02.2003, 08.2005 aralbrec

XLIB adt_ListTrim
LIB ADTListTrim

.adt_ListTrim
   call ADTListTrim
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty
;        HL = item removed from list
;        last item removed from list and current points to new last item
; uses : AF,BC,DE,HL
