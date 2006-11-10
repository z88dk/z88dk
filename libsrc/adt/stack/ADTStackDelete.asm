; void adt_StackDelete(struct adt_Stack **s, void *delete)
; 09.2005, 11.2006 aralbrec

XLIB ADTStackDelete
LIB l_jpix
XREF _u_free

; enter: HL = struct adt_Stack *
;        IX = void (*delete)(void *item) with HL,stack=item

.ADTStackDelete

   push hl                             ; save adt_Stack*
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                            ; hl = &adt_StackNode

.loop

   ld a,h
   or l
   jr z, donenodes
   
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

.donenodes

   pop hl                              ; hl = adt_Stack*
   push hl
   call _u_free                        ; free it
   pop hl
   ret
