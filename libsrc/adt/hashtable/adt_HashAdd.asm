; void *adt_HashAdd(struct adt_HashTable *ht, void *key, void *value)
; 09.2005 aralbrec

XLIB adt_HashAdd
LIB ADTHashAdd, l_jpix, l_jpiy

.adt_HashAdd
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)                ; de = value
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                ; bc = key
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                   ; hl = struct adt_HashTable

   push de                  ; stack = value
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
   push de                  ; stack = value, hash table address
   ld d,(hl)
   dec hl
   ld e,(hl)                ; de = table size
   ld hl,hashfunc
   call ADTHashAdd
   ccf 
   ret nc
   ex de,hl
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
