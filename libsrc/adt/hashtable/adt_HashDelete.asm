; void adt_HashDelete(struct adt_HashTable *ht)
; 09.2005 aralbrec

XLIB adt_HashDelete
LIB ADTHashDelete, l_jpiy
XREF _u_free

.adt_HashDelete
   push hl               ; save struct adt_HashTable
   ld c,(hl)
   inc hl
   ld b,(hl)             ; bc = table size
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)             ; de = address of hash table
   inc hl
   inc hl
   inc hl
   inc hl
   inc hl
   ld a,(hl)
   ld iyl,a
   inc hl
   ld a,(hl)
   ld iyh,a              ; iy = address of C delete function
   ld ix,delete
   or iyl
   jr nz, notzero
   ld ix,0
.notzero
   ex de,hl              ; hl = address of hash table
   call ADTHashDelete
   pop hl
   jp _u_free            ; free struct adt_HashTable itself and return

.delete
   push hl
   call l_jpiy
   pop hl
   ret
