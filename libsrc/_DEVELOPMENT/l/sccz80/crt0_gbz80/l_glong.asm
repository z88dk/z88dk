;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
		PUBLIC    l_glong
		PUBLIC    l_glonghlp


;Fetch long dehl from (hl)

.l_glonghlp
   ld a,(hl+)
   ld h,(hl)
   ld l,a

.l_glong

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld l,c
   ld h,b
   ret
