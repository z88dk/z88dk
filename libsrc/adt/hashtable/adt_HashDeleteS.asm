; void adt_HashDeleteS(struct adt_HashTable *ht)
; 09.2005 aralbrec

XLIB adt_HashDeleteS
LIB ADTHashDelete

.adt_HashDeleteS
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
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a              ; ix = address of C delete function
   ex de,hl              ; hl = address of hash table
   jp ADTHashDelete
