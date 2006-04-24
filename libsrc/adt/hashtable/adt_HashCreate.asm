; struct adt_HashTable *adt_HashCreate(uint size, void *delete, void *compare, void *hashfunc)
; 09.2005 aralbrec

XLIB adt_HashCreate
XREF _u_malloc, _u_free

.adt_HashCreate
   ld hl,10             ; sizeof(struct adt_HashTable)
   push hl
   call _u_malloc       ; get some memory for the table structure
   pop bc
   ret nc               ; return with HL = 0 if allocation failed

   ex de,hl
   ld hl,8
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a               ; hl = table size
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d            ; save size into struct adt_HashTable
   inc hl
   push hl              ; push &new adt_HashTable->table
   ex de,hl
   add hl,hl
   push hl
   call _u_malloc       ; try to get memory for the hash table
   pop bc
   jr c, cont
   pop hl               ; unsuccessful so clean up
   dec hl
   dec hl
   push hl
   call _u_free
   pop hl
   ld hl,0
   ret                  ; return with HL = 0 to indicate no memory

.cont
   pop de
   ex de,hl             ; de = address of hash table, hl = &new adt_HashTable->table
   ld (hl),e            ; store hash table address into hashtable struct
   inc hl
   ld (hl),d
   inc hl               ; hl = &new adt_HashTable->compare

   pop af               ; af = return address, careful!
   pop bc               ; bc = hashfunc
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   pop bc               ; bc = compare
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   pop bc               ; bc = delete
   ld (hl),c
   inc hl
   ld (hl),b
   push af
   push af
   push af
   push af

   ld bc,-8
   add hl,bc
   ld a,(hl)
   dec hl
   push hl              ; stack = address of new hashtable struct
   ld l,(hl)
   ld h,a
   add hl,hl
   ld c,l
   ld b,h               ; bc = size*2
   ld l,e
   ld h,d               ; hl = address of hash table
   inc de
   ld (hl),0
   dec bc
   ldir                 ; clear hash table to zeroes

   pop hl               ; return with hl = & new struct adt_HashTable
   ret
