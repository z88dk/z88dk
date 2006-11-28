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
   ret
