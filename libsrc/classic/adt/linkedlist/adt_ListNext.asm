; void __FASTCALL__ *adt_ListNext(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListNext
PUBLIC _adt_ListNext
EXTERN adt_ListFirst

.adt_ListNext
._adt_ListNext

; enter: hl = struct adt_List *
; exit : no carry = list empty or current pointer is past end of list, hl = 0 else:
;        hl = next item after current in list
;        current pointer changed to point at next item in list
; uses : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   jr z, fail             ; fail if no items in list
   
   inc hl                 ; hl = state
   ld a,(hl)              ; 0 = BEFORE, 1 = INLIST, 2 = AFTER
   or a
   jp z, adt_ListFirst + 6   ; BEFORE, so do ListFirst
   dec a
   jr nz, fail            ; return failure if current is AFTER end of list

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
   ex de,hl
   scf
   ret

.movedpastend             ; hl = current+1, de = current NODE.next

   ld (hl),0
   dec hl
   ld (hl),0              ; mark current pointing at nothing
   dec hl
   ld (hl),2              ; mark current pointing after end of list

.fail

   ld hl,0
   ret
