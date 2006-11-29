; void adt_HashCreateS(void *delete, void *compare, void *hashfunc, void *table, uint size, struct adt_HashTable *ht)
; 11.2006 aralbrec

XLIB adt_HashCreateS

.adt_HashCreateS

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld bc,10
   ldir
   ld hl,4
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   add hl,hl
   ld c,l
   ld b,h
   ld l,e
   ld h,d
   ld (hl),0
   inc de
   dec bc
   ldir
   ret
