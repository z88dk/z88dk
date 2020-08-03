

	SECTION	code_fp_mbf32
	PUBLIC	ldexp

; float ldexpf (float x, int16_t pw2)
ldexp:
    ld      hl,2
    add     hl,sp
    ld      c,(hl)	;pw2
    ld      hl,7	
    add     hl,sp	;exponent
    ld      a,(hl)
    and     a
    jr      z,skip
    add     c
skip:
    ld      d,a
    dec     hl
    ld      e,(hl)
    dec     hl
    ld      a,(hl)
    dec     hl
    ld      l,(hl)
    ld      h,a
    ret
