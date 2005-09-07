; void *adt_HashLookup(struct adt_HashTable *ht, void *key)
; 09.2005 aralbrec

XLIB adt_HashLookup
LIB ADTHashLookup, l_jpix, l_jpiy

.adt_HashLookup
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)                ; bc = key
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                   ; hl = struct adt_HashTable

   ld de,7
   add hl,de
   ld a,(hl)
   ld iyh,a
   dec hl
   ld a,(hl)
   ld iyl,a                 ; iy = C compare function
   dec hl
   ld a,(hl)
   ld ixh,a
   dec hl
   ld a,(hl)
   ld ixl,a                 ; ix = C hash function
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                ; de = address of hash table
   dec hl
   push de                  ; push hash table address on stack
   ld d,(hl)
   dec hl
   ld e,(hl)                ; de = table size
   ld hl,hashfunc
   call ADTHashLookup
   ccf
   ex de,hl
   ret nc
   ld hl,0
   ret

.hashfunc
   push bc
   push de
   call l_jpix
   pop de
   pop bc
   ld ix,compare
   ret

.compare
   push hl
   push bc
   push de
   call l_jpiy
   ld a,l
   pop de
   pop bc
   pop hl
   ret
