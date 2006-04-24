; int adt_StackPush(struct adt_Stack **s, void *item)
; 09.2005 aralbrec

XLIB ADTStackPush
XREF _u_malloc

; push item onto stack and update stack ptr
;
; enter: HL = struct adt_Stack **
;        DE = item
; exit : HL = 0 if fail (insufficient memory) with no carry
;        carry set if success

.ADTStackPush
   push hl
   push de
   ld hl,4             ; sizeof(struct adt_Stack)
   push hl
   call _u_malloc
   pop bc
   pop bc              ; bc = item
   pop de              ; de = adt_Stack **
   ret nc              ; mem alloc failed, hl = 0

   ld (hl),c           ; hl = & new adt_Stack
   inc hl
   ld (hl),b           ; store item
   inc hl
   ex de,hl            ; hl = adt_Stack **, de = &adt_Stack.next
   ldi
   ldi                 ; put new stack container at front of list

   ex de,hl            ; de = adt_Stack ** + 2b, hl = &adt_Stack.next + 2b
   dec de              ; write user's stack ptr with new
   ld bc,-4            ;  front adt_Stack container
   add hl,bc
   ex de,hl
   ld (hl),d
   dec hl
   ld (hl),e
   scf
   ret
