

        SECTION code_fp_mbf64

        PUBLIC  l_f64_dpush2

	EXTERN	___mbf64_FA

;------------------------------------------------------
; Push FA onto stack under ret address and stacked int
;------------------------------------------------------
l_f64_dpush2:
	pop     de
	pop	bc
        ld      hl,(___mbf64_FA + 6)
        push    hl
        ld      hl,(___mbf64_FA + 4)
        push    hl
        ld      hl,(___mbf64_FA + 2)
        push    hl
        ld      hl,(___mbf64_FA + 0)
        push    hl
	push	bc
	ex	de,hl
	jp	(hl)
