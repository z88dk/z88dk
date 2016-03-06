;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC    l_long_neg

; deHL = -deHL

.l_long_neg

   ld a,l
   cpl
   ld l,a
   ld a,h
   cpl
   ld h,a
   ld a,e
   cpl
   ld e,a
   ld a,d
   cpl
   ld d,a
   inc l
   ret nz
   inc h
   ret nz
   inc de
   ret

;        call    l_long_com
;        inc hl
;        ld a,h
;        or l
;        ret nz
;        inc de
;        ret
