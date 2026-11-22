; void __FASTCALL__ *adt_ListPrev(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListPrev
PUBLIC _adt_ListPrev
EXTERN adt_ListLast, l_setmem

.adt_ListPrev
._adt_ListPrev

; enter: hl = struct adt_List *
; exit : no carry = list empty or current pointer is before start of list and hl = 0 else:
;        hl = prev item before current in list
;        current pointer changed to point at prev item in list
; uses : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   ret z                  ; fail if no items in list
   inc hl                 ; hl = state
   ld a,(hl)              ; 0 = BEFORE, 1 = INLIST, 2 = AFTER
   or a
   ret z                  ; return failure if current is BEFORE start of list
   dec a
   jp nz, adt_ListLast+5  ; if current pointer is past end of list

   ; current pointer INLIST

   inc hl
   ld d,(hl)
   inc hl                 ; hl = current + 1
   ld e,(hl)              ; de = current->NODE
   inc de
   inc de
   inc de
   inc de                 ; de = NODE.prev
   ld a,(de)              ; if NODE->prev == NULL, moving past start of list
   or a
   jr z, movedpaststart
   ld b,a
   inc de
   ld a,(de)
   ld e,a
   ld d,b                 ; de = NODE->prev
   ld (hl),e
   dec hl
   ld (hl),d              ; current ptr = prev NODE
   ex de,hl               ; hl = prev NODE
   ld e,(hl)
   inc hl
   ld d,(hl)              ; de = list item
   scf
   ret

.movedpaststart           ; hl = current+1, de = current NODE.prev

   xor a
   call l_setmem-5        ; set 3 bytes to zero at hl
   ld l,a
   ld h,a
   ret                    ; carry flag reset indicates failure
