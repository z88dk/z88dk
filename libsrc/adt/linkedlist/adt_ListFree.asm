; void adt_ListFree(struct adt_List *list, void *free)
; /* void (*free)(void *item) */
; 02.2003, 06.2005 aralbrec

XLIB adt_ListFree
LIB ADTListFree

.adt_ListFree
   ld hl,2
   add hl,sp
   ld a,(hl)
   ld ixl,a
   inc hl
   ld d,(hl)
   ld ixh,d
   or d
   jr nz, notnull
   ld ix,justret
.notnull
   inc hl
   ld e,(hl)
   inc hl
   ld h,(hl)
   ld l,e
   jp ADTListFree

.justret
   ret

; enter: HL = struct adt_List *
;        IX = free
; exit : The entire list is deleted.
;        (free) is called once for each item in the list with
;          HL = item.
; uses : AF,BC,DE,HL
