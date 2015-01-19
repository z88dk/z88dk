;
;	Z88dk Generic Floating Point Math Library
;
;	bc ix de = (hl)


		PUBLIC	ldbchl

.ldbchl ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        defb    $dd
        ld      l,c
        inc     hl
        ld      c,(hl)
        defb    $dd
        ld      h,c
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
	ret

