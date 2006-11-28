; void adt_ListDelete(struct adt_List *list, void *delete)
; /* void __FASTCALL__ (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

XLIB ADTListDelete
LIB ADTListDeleteS
XREF _u_free

; enter: HL = struct adt_List *
;        IX = delete with HL = item
; exit : The entire list is deleted.
;        (delete) is called once for each item in the list with
;          HL = item and stack=item
; uses : AF,BC,DE,HL

.ADTListDelete
   push hl               ; save list
   call ADTListDeleteS
   pop hl                ; hl = list
   push hl
   call _u_free          ; free list container
   pop hl
   ret
