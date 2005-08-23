; void *adt_ListNext(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListNext
LIB ADTListFirst

; enter: HL = struct adt_List *
; exit : no carry = list empty or current pointer is past end of list, else:
;        DE = next item after current in list
;        current pointer changed to point at next item in list
; uses : AF,BC,DE,HL

.ADTListNext
   ld a,(hl)
   inc hl
   or (hl)
   ret z                  ; fail if no items in list
   inc hl                 ; hl = state
   ld a,(hl)              ; 0 = BEFORE, 1 = INLIST, 2 = AFTER
   or a
   jp z, ADTListFirst+5   ; BEFORE, so do ListFirst
   dec a
   ret nz                 ; return failure if current is AFTER end of list

   ; current pointer INLIST

   inc hl
   ld d,(hl)
   inc hl                 ; hl = current + 1
   ld e,(hl)              ; de = NODE for current ptr
   inc de
   inc de                 ; de = NODE.next
   ld a,(de)              ; if NODE->next == NULL, moving past end of list
   or a
   jr z, movedpastend
   ld b,a
   inc de
   ld a,(de)
   ld e,a
   ld d,b                 ; de = NODE->next
   ld (hl),e
   dec hl
   ld (hl),d              ; current ptr = next NODE
   ex de,hl               ; hl = next NODE
   ld e,(hl)
   inc hl
   ld d,(hl)              ; de = list item
   scf
   ret

.movedpastend             ; hl = current+1, de = current NODE.next
   ld (hl),0
   dec hl
   ld (hl),0              ; mark current pointing at nothing
   dec hl
   ld (hl),2              ; mark current pointing after end of list
   ret                    ; carry flag reset indicates failure
