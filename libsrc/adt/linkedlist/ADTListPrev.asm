; void *adt_ListPrev(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListPrev
LIB ADTListLast

; enter: HL = struct adt_List *
; exit : no carry = list empty or current pointer is before start of list, else:
;        DE = prev item before current in list
;        current pointer changed to point at prev item in list
; uses : AF,BC,DE,HL

.ADTListPrev
   ld a,(hl)
   inc hl
   or (hl)
   ret z                  ; fail if no items in list
   inc hl                 ; hl = state
   ld a,(hl)              ; 0 = BEFORE, 1 = INLIST, 2 = AFTER
   or a
   ret z                  ; return failure if current is BEFORE start of list
   dec a
   jp nz, ADTListLast+5   ; if current pointer is past end of list

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
   ld (hl),0
   dec hl
   ld (hl),0              ; mark current pointing at nothing
   dec hl
   ld (hl),0              ; mark current pointing before start of list
   ret                    ; carry flag reset indicates failure
