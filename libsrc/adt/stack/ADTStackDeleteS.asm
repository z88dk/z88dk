; void adt_StackDeleteS(struct adt_Stack **s, void *delete)
; 11.2006 aralbrec

XLIB ADTStackDeleteS
LIB l_jpix
XREF _u_free

; delete all items in stack but not adt_Stack struct itself
;
; enter: HL = struct adt_Stack *
;        IX = void (*delete)(void *item) with HL,stack=item

.ADTStackDeleteS

   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                            ; hl = &adt_StackNode

.loop

   ld a,h
   or l
   ret z
   
   push hl                             ; save node address
   ld c,(hl)
   inc hl
   ld b,(hl)                           ; bc = item
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   push de                             ; save next node
   ld l,c
   ld h,b
   push hl
   call l_jpix                         ; user delete function
   pop hl
   pop hl
   ex (sp),hl                          ; stack = next node, hl = current node
   push hl
   call _u_free                        ; free this node
   pop hl
   pop hl                              ; do it all again for next node
   jp loop
