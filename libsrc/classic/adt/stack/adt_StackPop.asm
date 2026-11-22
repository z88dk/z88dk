; void __FASTCALL__ *adt_StackPop(struct adt_Stack *s)
; 09.2005, 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackPop
PUBLIC _adt_StackPop
EXTERN _u_free

; pop item off the top of stack and update stack ptr
;
; enter: HL = struct adt_Stack *
; exit : HL = item at top of stack or 0 if stack empty
;             carry flag also set if stack not empty

.adt_StackPop
._adt_StackPop

   ld a,(hl)
   dec (hl)
   inc hl
   or a
   jp nz, nodec
   or (hl)
   jr z, fail
   dec (hl)

.nodec

   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl          ; de = &adt_Stack.next + 1b, hl = &adt_StackNode

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

.fail

   dec hl
   ld (hl),a
   ld l,a
   ld h,a
   ret
