; void __FASTCALL__ *adt_ListPopBack(struct adt_List *list)
; alias for adt_ListTrim(), new more STL-like name
; 11.2006 aralbrec

XLIB adt_ListPopBack
LIB ADTListTrim

.adt_ListPopBack
   call ADTListTrim
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_List *
; exit : no carry = list empty
;        HL = item removed from list
;        last item removed from list and current points to new last item
; uses : AF,BC,DE,HL
