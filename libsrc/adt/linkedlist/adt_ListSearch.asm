; void *adt_ListSearch(struct adt_List *list, void *match, void *item1)
; 02.2003, 08.2005 aralbrec

XLIB adt_ListSearch
LIB ADTListSearch, l_jpiy

.adt_ListSearch
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld iyl,c
   ld iyh,b
   ld ix,compare
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   call ADTListSearch
   ld l,c
   ld h,b
   ret c
   ld hl,0
   ret

.compare
   push hl
   push de
   push bc
   call l_jpiy
   ld a,l
   pop bc
   pop de
   pop hl
   or a
   ret nz
   scf
   ret

; enter: HL = struct adt_List *
;        DE = item1 *
;        IX = void (*match)(DE = void *item1, BC = void *item2)  -- MUST PRESERVE BC,DE,IX,HL
;             sets carry if equal
; exit : no carry = item not found, current points past end of list
;        else  BC = item found, current points at found item
; uses : AF,BC,DE,HL
