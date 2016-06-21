;
;	Z88dk Generic Floating Point Math Library
;
;	bc ix de = (hl)

        SECTION code_fp
	PUBLIC	ldbchl

.ldbchl ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        ld      ixl,c
        inc     hl
        ld      c,(hl)
        ld      ixh,c
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
	ret

