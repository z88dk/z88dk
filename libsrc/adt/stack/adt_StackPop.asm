; void __FASTCALL__ *adt_StackPop(struct adt_Stack *s)
; 09.2005, 11.2006 aralbrec

XLIB adt_StackPop
XREF _u_free

; pop item off the top of stack and update stack ptr
;
; enter: HL = struct adt_Stack *
; exit : HL = item at top of stack or 0 if stack empty
;             carry flag also set if stack not empty

.adt_StackPop
   ld c,l
   ld b,h            ; bc = &adt_Stack.count
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl          ; de = &adt_Stack.next + 1b, hl = &adt_StackNode

   ld a,h
   or l
   ret z             ; ret if empty stack with hl=0

   ld a,(bc)         ; decrease stack count
   dec a
   ld (bc),a
   inc a
   jr nz, nohi
   inc bc
   ld a,(bc)
   dec a
   ld (bc),a

.nohi

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
   push hl
   call _u_free      ; free adt_StackNode container
   pop hl
   pop hl            ; hl = item
   scf
   ret
