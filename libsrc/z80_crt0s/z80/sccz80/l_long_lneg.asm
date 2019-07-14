;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC    l_long_lneg

; deHL = !deHL
; set carry if result true and return val in dehl

.l_long_lneg

        ld a,h
        or l
        or      e
        or      d
        jr z,l_long_lneg1

        ld hl,0
	ld	d,h
	ld	e,l
        ret
        
.l_long_lneg1
  
        inc l
	scf
        ret
