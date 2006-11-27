; void __FASTCALL__ *adt_ListPopFront(struct adt_List *list)
; 11.2006 aralbrec

XLIB adt_ListPopFront
LIB ADTListPopFront

.adt_ListPopFront

   call ADTListPopFront
   ret c
   ld hl,0
   ret
