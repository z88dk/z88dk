; uint __FASTCALL__ adt_StackCount(struct adt_Stack *s)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackCount
PUBLIC _adt_StackCount

; return number of items in stack
;
; enter: HL = struct adt_Stack *
; exit : HL = number of items

.adt_StackCount
._adt_StackCount
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret
