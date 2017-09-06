;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC    l_glonghlp

; 
;  call_l_gint
;  call l_glong


;Fetch long dehl from *(hl)

.l_glonghlp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

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
