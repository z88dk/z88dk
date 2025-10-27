;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_glong
PUBLIC    l_glonghlp


; Pick up long from (*hl)
.l_glonghlp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

;Fetch long dehl from (hl)
.l_glong
   inc hl
   inc hl
   inc hl
   ld  d,(hl)
   dec hl
   ld  e,(hl)
   dec hl
   ld  a,(hl-)
   ld l,(hl)
   ld h,a
   ret
