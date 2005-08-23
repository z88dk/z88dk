; void *adt_ListCurr(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListCurr

; enter: HL = struct adt_List *
; exit : no carry = list empty or current points outside list, else:
;        DE = current item in list
; uses : AF,DE,HL

.ADTListCurr
   ld a,(hl)
   inc hl
   or (hl)
   ret z               ; nothing in list
   inc hl
   ld a,(hl)           ; state of current pointer 0=BEFORE, 1=INLIST, 2=AFTER
   dec a
   ret nz              ; if not INLIST, not pointing at an item, nc=failure
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)           ; de = current's NODE
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)           ; de = current NODE's item
   scf
   ret
