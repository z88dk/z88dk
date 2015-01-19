; void __FASTCALL__ *adt_StackPeek(struct adt_Stack *s)
; 09.2005, 11.2006 aralbrec

PUBLIC adt_StackPeek

; return the item at the top of the stack
; but don't pop it!
;
; enter: HL = struct adt_Stack *
; exit : HL = item at top of stack or 0 if stack empty

.adt_StackPeek

   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   or h
   ret z
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret
