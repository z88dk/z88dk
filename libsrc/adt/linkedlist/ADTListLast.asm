; void *adt_ListLast(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListLast

; enter: HL = struct adt_List *
; exit : no carry = list empty, else:
;        DE = item at end of list
;        current pointer changed to point at last item in list
; uses : AF,BC,DE,HL

.ADTListLast
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
   ld e,(hl)
   dec hl
   ld d,(hl)           ; de = NODE stored at tail of list
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)           ; de = item
   scf
   ret
