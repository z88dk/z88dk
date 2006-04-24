; void adt_ListDelete(struct adt_List *list, void *delete)
; /* void (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

XLIB adt_ListDelete
LIB ADTListDelete

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
   jp ADTListDelete

.justret
   ret

; enter: HL = struct adt_List *
;        IX = delete
; exit : The entire list is deleted.
;        (delete) is called once for each item in the list with
;          HL = item and stack=item
; uses : AF,BC,DE,HL
