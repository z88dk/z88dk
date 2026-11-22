; void __FASTCALL__ *adt_ListLast(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListLast
PUBLIC _adt_ListLast

.adt_ListLast
._adt_ListLast

; enter: hl = struct adt_List *
; exit : no carry = list empty, hl = 0 else:
;        hl = item at end of list
;        current pointer changed to point at last item in list
; uses : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   ret z               ; nothing in list
   
   inc hl
   ld (hl),1           ; current will be INLIST
   inc hl
   ld e,l
   ld d,h              ; de points at current
   ld hl,4
   add hl,de           ; hl points at tail
   ldi
   ldi                 ; copy tail to current
   dec hl
   
   ld a,(hl)
   dec hl
   ld h,(hl)           ; hl = NODE stored at tail of list
   ld l,a
   
   ld a,(hl)
   inc hl
   ld h,(hl)           ; hl = item
   ld l,a
   scf
   ret
