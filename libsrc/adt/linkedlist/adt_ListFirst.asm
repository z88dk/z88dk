; void *adt_ListFirst(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListFirst
LIB ADTListFirst

.adt_ListFirst
   call ADTListFirst
   ex de,hl
   ret c
   ld hl,0
   ret

; enter: HL = struct adt_list *
; exit : DE = item at start of list
;        current pointer changed to point at first item in list
;        IF FAIL: carry reset
; uses : AF,BC,DE,HL