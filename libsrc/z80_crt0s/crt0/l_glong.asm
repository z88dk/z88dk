;       Z88 Small C+ Run Time Library 
;       Long functions
;

PUBLIC    l_glong


;Fetch long dehl from (hl)

.l_glong

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   ret
