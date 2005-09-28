; void *adt_StackPop(struct adt_Stack **s)
; 09.2005 aralbrec

XLIB adt_StackPop
XREF _u_free

; pop item off the top of stack and update stack ptr
;
; enter: HL = struct adt_Stack **
; exit : HL = item at top of stack or 0 if stack empty
;             carry flag also set if stack not empty
;        stack ptr modified to point at next item

.adt_StackPop
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl          ; de = adt_Stack ** + 1b, hl = adt_Stack *

   ld a,h
   or l
   ret z             ; ret if empty stack with hl=0

   ld c,(hl)
   inc hl
   ld b,(hl)
   push bc           ; stack = item
   inc hl
   ld a,(hl)
   inc hl
   ldd
   ld (de),a         ; write new stack ptr
   dec hl
   dec hl
   call _u_free      ; free stack container
   pop hl            ; hl = item
   scf
   ret
