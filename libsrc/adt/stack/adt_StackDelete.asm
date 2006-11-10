; void adt_StackDelete(struct adt_Stack *s, void *delete)
; 09.2005 aralbrec

XLIB adt_StackDelete
LIB ADTStackDelete

.adt_StackDelete
   ld hl,2
   add hl,sp
   ld e,(hl)
   ld ixl,e
   inc hl
   ld a,(hl)
   ld ixh,a
   inc hl
   or e
   jr nz, valid
   ld ix,justret
.valid
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp ADTStackDelete
.justret
   ret
