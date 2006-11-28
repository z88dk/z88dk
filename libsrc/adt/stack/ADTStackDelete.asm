; void adt_StackDelete(struct adt_Stack **s, void *delete)
; 09.2005, 11.2006 aralbrec

XLIB ADTStackDelete
LIB ADTStackDeleteS
XREF _u_free

; enter: HL = struct adt_Stack *
;        IX = void (*delete)(void *item) with HL,stack=item

.ADTStackDelete

   push hl                             ; save adt_Stack*
   call ADTStackDeleteS                ; delete all items in stack
   pop hl                              ; hl = adt_Stack*
   push hl
   call _u_free                        ; free it
   pop hl
   ret
